defmodule GrixWeb.XWSController do
  use GrixWeb, :controller

  alias Grix.Squad
  alias Grix.Archetype
  alias Grix.XWS
  alias Grix.Helpers.Html


  def new(conn, _params) do
    {:ok, archetypes} = Archetype.list()

    conn
    |> assign(:archetypes, Html.as_options(archetypes))
    |> render("new.html")
  end

  def generate(conn, params) do
    case XWS.is_valid(params["xws"]) do
      :true ->
        {:ok, squad} = Squad.generate_from_xws(params["xws"])
        translated_squad = XWS.translate_squad(squad)
        {:ok, squad_pid} = Agent.start_link(fn -> translated_squad end)

        conn
        |> put_session(:xws_squad_pid, squad_pid)
        |> assign(:archetype, params["archetype"])
        |> assign(:squad, squad)
        |> render("specify.html")
      {:error, msg} ->
        conn
        |> put_flash(:error, msg)
        |> new(nil)
      _ ->
        conn
        |> put_flash(:error, "Could not parse xws")
        |> new(nil)
    end
  end

  def create(conn, params) do
    squad_pid = get_session(conn, :xws_squad_pid)
    saved_squad = Agent.get(squad_pid, fn s -> s end)

    xws_with_points = XWS.update_points(saved_squad, params)

    {:ok, squad_id} = Squad.create(saved_squad.name, saved_squad.faction, saved_squad.archetype, saved_squad.xws)
    squad_with_id = %{xws_with_points | :id => squad_id}
    :ok = Squad.persist_ships(squad_with_id)

    redirect(conn, to: Routes.squad_path(conn, :index))
  end
end

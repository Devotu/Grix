defmodule GrixWeb.SquadController do
  use GrixWeb, :controller

  alias Grix.Squad
  alias Grix.Score
  alias Grix.Game
  alias Grix.Faction
  alias Grix.Archetype
  alias Grix.Helpers.Html

  def new(conn, _params) do
    {:ok, factions} = Faction.list()
    {:ok, archetypes} = Archetype.list()

    conn
    |> assign(:factions, Html.as_options(factions))
    |> assign(:archetypes, Html.as_options(archetypes))
    |> render("new.html")
  end

  def index(conn, _params) do
    case Squad.list() do
      {:ok, list} ->
        conn
        |> assign(:squads, list)
        |> render("list.html")
      _ ->
        conn
        |> put_flash(:error, "?")
        |> redirect(to: Routes.main_path(conn, :show))
    end
  end

  def show(conn, params) do
    squad_id = params["id"]

    case Squad.get(squad_id) do
      {:ok, squad} ->
        {:ok, average} = Score.squad_average(squad_id)
        {:ok, win_percent} = Game.squad_win_percentage(squad_id)

        conn
        |> assign(:squad, squad)
        |> assign(:stats, %{average: average, win_percent: win_percent})
        |> render("show.html")
      {:error, :not_found} ->
        conn
        |> put_flash(:error, "No such squad")
        |> render("new.html")
      _ ->
        conn
        |> put_flash(:error, "?")
        |> render("new.html")
    end
  end


  def create(conn, params) do
    # case Squad.create(params["name"], params["faction"], params["archetype"], params["xws"]) do
    #   {:ok, id} ->
    #     {:ok, squad} = Squad.get(id)
    #     conn
    #     |> assign(:squad, squad)
    #     |> render("show.html")
    #   {:error, _kind, msg} ->
    #     conn
    #     |> put_flash(:error, msg)
    #     |> render("new.html")
    #   _ ->
    #     :error
    # end

    case Poison.decode(params["xws"]) do
      {:ok, xws} ->
        IO.inspect(xws, label: "xws")
        conn
        |> assign(:name, params["name"])
        |> assign(:faction, params["faction"])
        |> assign(:archetype, params["archetype"])
        |> assign(:xws, xws)
        |> render("specify.html")
      _ ->
        conn
        |> put_flash(:error, "Could not parse xws")
        |> new(nil)
    end
  end
end

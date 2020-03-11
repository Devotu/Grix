defmodule GrixWeb.SquadController do
  use GrixWeb, :controller

  alias Grix.Squad
  alias Grix.Score
  alias Grix.Game
  alias Grix.Faction
  alias Grix.Archetype
  alias Grix.XWS
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


  def create(conn, %{"xws" => ""} = params) do
    case Poison.decode(params["xws"]) do
      {:ok, xws} ->
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

  def create(conn, params) do
    case XWS.is_valid(params["xws"]) do
      :ok ->
        {:ok, squad} = Squad.generate_from_xws(params["xws"])
        conn
        |> assign(:name, squad.name)
        |> assign(:faction, squad.faction)
        |> assign(:archetype, params["archetype"])
        |> assign(:xws, squad.xws)
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
end

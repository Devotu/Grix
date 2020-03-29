defmodule GrixWeb.SquadController do
  use GrixWeb, :controller

  alias Grix.Squad
  alias Grix.Score
  alias Grix.Game
  alias Grix.Faction
  alias Grix.Archetype
  alias Grix.Ship
  alias Grix.Card
  alias Grix.Helpers.Html
  alias Grix.Helpers.General, as: Helpers

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
        {:ok, ships} = Ship.get_ships_in_squad(squad_id)

        upgraded_ships = ships
        |> Enum.map(fn s -> {s, Card.get_cards_for_ship(s.id)} end)
        |> IO.inspect(label: "1: ")
        |> Enum.map(fn {s, cr} -> {s, Helpers.without_ok(cr)} end)
        |> IO.inspect(label: "2: ")
        |> Enum.map(fn {s, cs} -> Ship.assign_upgrades(s, cs) end)
        |> IO.inspect(label: "3: ")

        IO.inspect(ships, label: "ships: \n")
        {:ok, squad_with_ships} = Squad.assign_ships(squad, upgraded_ships)

        conn
        |> assign(:squad, squad_with_ships)
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
    case Squad.create(params["name"], params["faction"], params["archetype"], params["xws"]) do
      {:ok, id} ->
        {:ok, squad} = Squad.get(id)
        conn
        |> assign(:squad, squad)
        |> render("show.html")
      {:error, _kind, msg} ->
        conn
        |> put_flash(:error, msg)
        |> render("new.html")
      _ ->
        :error
    end
  end
end

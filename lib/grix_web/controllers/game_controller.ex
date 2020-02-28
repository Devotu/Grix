defmodule GrixWeb.GameController do
  use GrixWeb, :controller

  alias Grix.Game
  alias Grix.Faction
  alias Grix.Archetype
  alias Grix.Squad
  alias Grix.Player

  alias Grix.Helpers.Html

  def new(conn, _params) do
    case Map.has_key?(conn.assigns, :player) do
      :true ->
        {:ok, factions} = Faction.list()
        {:ok, archetypes} = Archetype.list()
        {:ok, squads} = Squad.list()
        {:ok, players} = Player.list()

        conn
        |> assign(:factions, Html.as_options(factions))
        |> assign(:archetypes, Html.as_options(archetypes))
        |> assign(:squads, Html.as_options(squads))
        |> assign(:players, Html.as_options(players))
        |> render("new.html")
      _ ->
        redirect(conn, to: Routes.login_path(conn, :show))
    end
  end


  def create(conn, _params) do
    case Game.create(conn.assigns.player.id) do
      {:ok, id} ->
        {:ok, game} = Game.get(id)
        conn
        |> assign(:game, game)
        |> render("show.html")
      {:error, _kind} ->
        conn
        |> put_flash(:error, "Could not create new game")
        |> render("new.html")
    end
  end

end

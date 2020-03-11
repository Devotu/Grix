defmodule GrixWeb.GameController do
  use GrixWeb, :controller

  alias Grix.Game
  alias Grix.Faction
  alias Grix.Archetype
  alias Grix.Squad
  alias Grix.Player
  alias Grix.Score

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


  def create(conn, params) do
    {:ok, squad_1} = Squad.get(params["squad_1"])
    {:ok, squad_2} = Squad.get(params["squad_2"])

    {:ok, game_id} = Game.create(conn.assigns.player.id)
    {:ok, score_1_id} = Score.create(params["player_1"], params["squad_1"], game_id, params["points_1"])
    {:ok, score_2_id} = Score.create(params["player_2"], params["squad_2"], game_id, params["points_2"])

    {:ok, game} = Game.get(game_id)
    {:ok, score_1} = Score.get(score_1_id)
    {:ok, score_2} = Score.get(score_2_id)

    conn
    |> assign(:game, game)
    |> assign(:score_1, score_1)
    |> assign(:score_2, score_2)
    |> assign(:squad_1, squad_1)
    |> assign(:squad_2, squad_2)
    |> render("show.html")
  end

end

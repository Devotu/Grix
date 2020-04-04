defmodule Grix.Game do
  alias Grix.Helpers.General, as: Helpers
  alias Grix.Helpers.Database
  alias Grix.Helpers.Calculator
  alias Grix.Game

  defstruct id: "", created: 0, registered: ""

  @spec create(any) :: {:error, :insert_failure} | {:ok, any}
  def create(player_id) do

    guid = Helpers.generate_guid()

    query = """
    MATCH
      (p:Player)
    WHERE
      p.id = "#{player_id}"
    CREATE
      (p)-[:Registered]->(g:Game {id:"#{guid}", created:TIMESTAMP()})
    RETURN g.id AS id;
    """

    Database.create_and_return(query, guid)
  end


  def list(squad_id) do
    query = """
    MATCH
      (p:Player)-[:Registered]->(g:Game)<-[:In]-(:Score)-[:With]->(sq:Squad)
    WHERE
      sq.id = "#{squad_id}"
    RETURN
      {
        id: g.id,
        created: g.created,
        registered: p.id
      } AS game
    """

    Database.get(query)
    |> nodes_to_games
    |> Helpers.return_as_tuple()
  end


  def list() do
    query = """
    MATCH
      (g:Game)<-[:Registered]-(p:Player)
    RETURN
      {
        id: g.id,
        created: g.created,
        registered: p.id
      } AS game
    """

    Database.get(query)
    |> nodes_to_games
    |> Helpers.return_as_tuple()
  end


  def get(id) do
    query = """
    MATCH
      (g:Game)<-[:Registered]-(p:Player)
    WHERE
      g.id = "#{id}"
    RETURN
      {
        id: g.id,
        created: g.created,
        registered: p.id
      } AS game
    """

    Database.get(query)
    |> nodes_to_games
    |> Helpers.return_expected_single
  end

  #Helpers
  defp nodes_to_games(nodes) do
    Enum.map(nodes, &node_to_game/1)
  end

  defp node_to_game(node) do
    data_map = Helpers.atomize_keys(node["game"])
    struct(Game, data_map)
  end


  def squad_win_percentage(squad_id) do
    query = """
    MATCH
      (ops:Score)-[:In]->(:Game)<-[:In]-(s:Score)-[:With]->(sq:Squad)
    WHERE
      sq.id = "#{squad_id}"
      AND s.points > ops.points
    RETURN
      {} AS game
    """

    {:ok, games} = Game.list(squad_id)
    count_games = Calculator.count(games)

    Database.get(query)
    |> nodes_to_games
    |> Calculator.count()
    |> Calculator.percentage(count_games)
    |> Helpers.return_as_tuple()
  end
end

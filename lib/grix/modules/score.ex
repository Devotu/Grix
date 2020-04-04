defmodule Grix.Score do
  alias Grix.Helpers.General, as: Helpers
  alias Grix.Helpers.Database
  alias Grix.Score
  alias Grix.Helpers.Calculator

  defstruct id: "", points: 0

  def create(player_id, squad_id, game_id, points) do

    guid = Helpers.generate_guid()

    query = """
    MATCH
      (p:Player), (sq:Squad), (g:Game)
    WHERE
      p.id = "#{player_id}"
      AND sq.id = "#{squad_id}"
      AND g.id = "#{game_id}"
    CREATE
      (p)-[:Got]->
      (s:Score {id:"#{guid}", points:#{points}, created:TIMESTAMP()})
      -[:With]->(sq),
      (s)-[:In]->(g)
    RETURN s.id AS id;
    """

    Database.create_and_return(query, guid)
  end


  def list(squad_id) do
    query = """
    MATCH
      (s:Score)-[:With]->(sq:Squad)
    WHERE
      sq.id = "#{squad_id}"
    RETURN
      {
        id: s.id,
        points: s.points
      } AS score
    """

    Database.get(query)
    |> nodes_to_scores
    |> Helpers.return_as_tuple()
  end


  def list() do
    query = """
    MATCH
      (s:Score)
    RETURN
      {
        id: s.id,
        points: s.points
      } AS score
    """

    Database.get(query)
    |> nodes_to_scores
    |> Helpers.return_as_tuple()
  end


  def get(id) do
    query = """
    MATCH
      (s:Score)
    WHERE
      s.id = "#{id}"
    RETURN
      {
        id: s.id,
        points: s.points
      } AS score
    """

    Database.get(query)
    |> nodes_to_scores
    |> Helpers.return_expected_single
  end

  #Helpers
  defp nodes_to_scores(nodes) do
    Enum.map(nodes, &node_to_score/1)
  end

  defp node_to_score(node) do
    data_map = Helpers.atomize_keys(node["score"])
    struct(Score, data_map)
  end


  def squad_average(squad_id) do
    {:ok, scores} = list(squad_id)
    average = scores
      |> Enum.map(&(&1.points))
      |> Calculator.average()

    {:ok, average}
  end
end

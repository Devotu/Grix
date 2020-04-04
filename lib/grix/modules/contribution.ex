defmodule Grix.Contribution do
  alias Grix.Helpers.General, as: Helpers
  alias Grix.Helpers.Database
  alias Grix.Contribution

  defstruct times: 0


  def add(score_id, ship_id, times) do
    query = """
      MATCH
        (s:Score), (s1:Ship)
      WHERE
        s.id = "#{score_id}"
        AND s1.id = "#{ship_id}"
      CREATE
        (s1)-[:Contributed {times: #{times}}]->(s);
    """

    Database.run(query)
  end


  def find(score_id, ship_id) do
    query = """
    MATCH
      (s1:Ship)-[c:Contributed]->(s:Score)
    WHERE
      s.id = "#{score_id}"
      AND s1.id = "#{ship_id}"
    RETURN
      {
        times: c.times
      } AS contribution
    """

    Database.get(query)
    |> nodes_to_contributions
    |> Helpers.return_expected_single
  end



  #Helpers
  defp nodes_to_contributions(nodes) do
    Enum.map(nodes, &node_to_contribution/1)
  end

  defp node_to_contribution(node) do
    struct(Contribution, Helpers.atomize_keys(node["contribution"]))
  end
end

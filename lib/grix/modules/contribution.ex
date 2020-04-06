defmodule Grix.Contribution do
  alias Grix.Helpers.General, as: Helpers
  alias Grix.Helpers.Database
  alias Grix.Contribution

  defstruct score_id: "", ship_id: "", times: 0


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

  def add(score_id, contributions) when is_list(contributions) do

    contributions_with_temp_id = Enum.map(contributions, fn c -> {Helpers.generate_lower_case_sequence(5), c} end)

    match = contributions_with_temp_id
    |> Enum.map_join(", ", fn {g,_c} -> write_add_match(g) end)
    |> IO.inspect(label: "match")

    where = contributions_with_temp_id
    |> Enum.map_join(" AND ", fn {g,c} -> write_add_where(c, g) end)
    |> IO.inspect(label: "where")

    create = contributions_with_temp_id
    |> Enum.map_join(", ", fn {g,c} -> write_add_create(c, g) end)
    |> IO.inspect(label: "create")

    query = """
      MATCH
        (s:Score), #{match}
      WHERE
        s.id = "#{score_id}"
        AND #{where}
      CREATE
        #{create}
      ;
    """

    Database.run(query)
  end


  def write_add_match(guid) do
    "(#{guid}:Ship)"
  end

  def write_add_where(%Contribution{} = c, guid) do
    "#{guid}.id = \"#{c.ship_id}\""
  end

  def write_add_create(%Contribution{} = c, guid) do
    "(#{guid})-[:Contributed {times: #{c.times}}]->(s)"
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

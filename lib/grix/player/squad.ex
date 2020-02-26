defmodule Grix.Squad do
  alias Grix.Helpers.General, as: Helpers
  alias Grix.Helpers.Database
  alias Grix.Squad

  defstruct id: "", name: "", archetype: "", faction: ""


  def create(name, faction, archetype) do

    guid = Helpers.generate_guid()

    query = """
    MATCH
      (at:Archetype), (f:Faction)
    WHERE
      at.id = "#{archetype}"
      AND f.id = "#{faction}"
    CREATE
      (f)<-[:Belongs]-
      (sq:Squad {id:"#{guid}", name:"#{name}", created:TIMESTAMP()})
      -[:Is]->(at)
    RETURN sq.id AS id;
    """

    Database.create(query, guid)
  end


  def get(id) do
    query = """
    MATCH
      (sq:Squad)
    WHERE
      sq.id = "#{id}"
    RETURN
      sq
    """

    Database.get(query)
    |> nodes_to_squads
    |> Helpers.return_expected_single
  end

  #Helpers
  defp nodes_to_squads(nodes) do
    Enum.map(nodes, &node_to_squad/1)
  end

  defp node_to_squad(node) do
    squad_map =
    node["sq"].properties
    |> Helpers.atomize_keys

    struct(Squad, squad_map)
  end
end

defmodule Grix.Squad do
  alias Grix.Helpers.General, as: Helpers
  alias Grix.Helpers.Database
  alias Grix.Squad

  defstruct id: "", name: "", archetype: "", faction: "", xws: ""


  def create("", _, _, _), do: {:error, :missing_parameter, "name"}
  def create(_, "", _, _), do: {:error, :missing_parameter, "faction"}
  def create(_, _, "", _), do: {:error, :missing_parameter, "archetype"}

  def create(name, faction, archetype, xws) do

    guid = Helpers.generate_guid()
    safe_xws = Database.to_safe_json(xws)

    query = """
    MATCH
      (at:Archetype), (f:Faction)
    WHERE
      at.id = "#{archetype}"
      AND f.id = "#{faction}"
    CREATE
      (f)<-[:Belongs]-
      (sq:Squad {id:"#{guid}", name:"#{name}", xws:"#{safe_xws}", created:TIMESTAMP()})
      -[:Is]->(at)
    RETURN sq.id AS id;
    """

    Database.create(query, guid)
  end


  def list() do
    query = """
    MATCH
      (f:Faction)<-[:Belongs]-
      (sq:Squad)
      -[:Is]->(at:Archetype)
    RETURN
      {
        id: sq.id,
        name: sq.name,
        archetype: at.name,
        faction: f.name,
        xws: sq.xws
      } AS squad
    """

    Database.get(query)
    |> nodes_to_squads
    |> IO.inspect(label: "got")
    |> Helpers.return_as_tuple()
  end


  def get(id) do
    query = """
    MATCH
      (f:Faction)<-[:Belongs]-
      (sq:Squad)
      -[:Is]->(at:Archetype)
    WHERE
      sq.id = "#{id}"
    RETURN
      {
        id: sq.id,
        name: sq.name,
        archetype: at.name,
        faction: f.name,
        xws: sq.xws
      } AS squad
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
    data_map = Helpers.atomize_keys(node["squad"])
    parsed_data_map = Map.put(data_map, :xws, Database.from_safe_json(data_map.xws))
    struct(Squad, parsed_data_map)
  end
end

defmodule Grix.Archetype do
  alias Grix.Helpers.General, as: Helpers
  alias Grix.Helpers.Database
  alias Grix.Archetype

  defstruct id: "", name: ""

  def list() do
    query = """
    MATCH
      (at:Archetype)
    RETURN
      {
        id: at.id,
        name: at.name
      } AS archetype
    """

    Database.get(query)
    |> nodes_to_archetypes
    |> Helpers.return_as_tuple()
  end


  #Helpers
  defp nodes_to_archetypes(nodes) do
    Enum.map(nodes, &node_to_archetype/1)
  end

  defp node_to_archetype(node) do
    archetype_map = Helpers.atomize_keys(node["archetype"])
    struct(Archetype, archetype_map)
  end
end

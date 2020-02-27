defmodule Grix.Faction do
  alias Grix.Helpers.General, as: Helpers
  alias Grix.Helpers.Database
  alias Grix.Faction

  defstruct id: "", name: ""

  def list() do
    query = """
    MATCH
      (f:Faction)
    RETURN
      {
        id: f.id,
        name: f.name
      } AS faction
    """

    Database.get(query)
    |> nodes_to_factions
    |> IO.inspect(label: "got")
    |> Helpers.return_as_tuple()
  end


  #Helpers
  defp nodes_to_factions(nodes) do
    Enum.map(nodes, &node_to_faction/1)
  end

  defp node_to_faction(node) do
    faction_map = Helpers.atomize_keys(node["faction"])
    struct(Faction, faction_map)
  end
end

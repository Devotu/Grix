defmodule Grix.Card do
  alias Grix.Helpers.General, as: Helpers
  alias Grix.Helpers.Database
  alias Grix.Card

  defstruct id: "", name: "", type: "", points: 0



  def create(name, category) do

    id = Database.generate_id(name)
    label = Database.convert_to_label(category)

    query = """
    CREATE
      (c:Card:#{label} {id:"#{id}", name:"#{name}", created:TIMESTAMP()})
    RETURN
      c.id AS id
    """

    Database.create(query, id)
  end


  def get(id) do
    query = """
    MATCH
      (c:Card)
    WHERE
      c.id = "#{id}"
    RETURN
      {
        id: c.id,
        name: c.name
      } AS card
    """

    Database.get(query)
    |> nodes_to_cards
    |> Helpers.return_expected_single
  end

  #Helpers
  defp nodes_to_cards(nodes) do
    Enum.map(nodes, &node_to_card/1)
  end

  defp node_to_card(node) do
    data_map = Helpers.atomize_keys(node["card"])
    struct(Card, data_map)
  end
end

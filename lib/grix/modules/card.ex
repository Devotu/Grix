defmodule Grix.Card do
  alias Grix.Helpers.General, as: Helpers
  alias Grix.Helpers.Database
  alias Grix.Card

  defstruct id: "", name: "", type: "", points: 0



  def create(id, name, category) do
    label = Database.convert_to_label(category)

    query = """
    CREATE
      (c:Card:#{label} {id:"#{id}", name:"#{name}", created:TIMESTAMP()})
    RETURN
      c.id AS id
    """

    Database.create(query, id)
  end

  def create(name, category) do
    create(Database.generate_id(name), name, category)
  end


  def get(ids) when is_list(ids) do

    found_in = Database.generate_in(ids)

    query = """
    MATCH
      (c:Card)
    WHERE
      c.id #{found_in}
    RETURN
      {
        id: c.id,
        name: c.name,
        tags: labels(c)
      } AS card
    """

    Database.get(query)
    |> nodes_to_cards
    |> Helpers.return_as_tuple()
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
        name: c.name,
        tags: labels(c)
      } AS card
    """

    Database.get(query)
    |> nodes_to_cards
    |> Helpers.return_expected_single
  end


  def get_or_create_from_xws({category, ids}) when is_list(ids) do
    ids
    |> Enum.map(fn id -> get_or_create_from_xws(category, id) end)
    |> Enum.map(&Helpers.without_ok/1)
  end

  def get_or_create_from_xws(category, id) do
    case get(id) do
      {:ok, card} ->
        card
      {:error, :not_found} ->
        create(id, Database.convert_to_name(id), category)
        |> Helpers.without_ok()
        |> get()
        |> Helpers.without_ok()
      _ ->
        {:error, :card_error}
    end
  end


  #Helpers
  defp nodes_to_cards(nodes) do
    Enum.map(nodes, &node_to_card/1)
  end

  defp node_to_card(node) do
    data_map = Helpers.atomize_keys(node["card"])
    struct(Card, data_map)
    |> Map.put(:type, select_type(data_map))
  end


  defp select_type(%{tags: tags}) do
    tags
    |> Enum.filter(&(&1 != "Card"))
    |> List.first()
    |> String.downcase()
  end

  defp select_type(_), do: ""
end

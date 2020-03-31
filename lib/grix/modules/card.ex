defmodule Grix.Card do
  alias Grix.Helpers.General, as: Helpers
  alias Grix.Helpers.Database
  alias Grix.Card
  alias Grix.Frame

  defstruct id: "", name: "", guid: "", type: "", points: 0



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
        IO.inspect(card.name, label: "Card - Found: ")
        card
      {:error, :not_found} ->
        IO.inspect(id, label: "Card - Created: ")
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
    |> assign_guid()
    |> assign_type(data_map)
  end


  def assign_guid(%Card{} = c) do
    Map.put(c, :guid, Helpers.generate_guid())
  end


  def assign_type(%Card{} = c, data_map) do
    Map.put(c, :type, select_type(data_map))
  end

  defp select_type(%{tags: tags}) do
    tags
    |> Enum.filter(&(&1 != "Card"))
    |> List.first()
    |> String.downcase()
  end

  defp select_type(_), do: ""


  def find_frame(%Card{} = c) do
    query = """
    MATCH
      (c:Card)-[:Flies]->(f:Frame)
    WHERE
      c.id = "#{c.id}"
    RETURN
      f.id AS id
    """

    Database.get(query)
    |> Map.get(:results)
    |> Enum.map(&(&1["id"]))
    |> List.first()
    |> Frame.get()
  end


  def write_persist_match(%Card{} = c) do
    "(#{c.id}:#{Database.convert_to_label(c.type)})"
  end


  def write_persist_where(%Card{} = c) do
    "#{c.id}.id = \"#{c.id}\""
  end


  def write_persist_create(%Card{} = c) do
    "(s)-[:Use {points: #{c.points}}]->(#{c.id})"
  end


  def get_cards_for_ship(ship_id) do

    query = """
    MATCH
      (s:Ship)-[u:Use]->(c:Card)
    WHERE
      s.id = "#{ship_id}"
    RETURN
      {
        id: c.id,
        name: c.name,
        tags: labels(c),
        points: u.points
      } AS card
    """

    Database.get(query)
    |> nodes_to_cards
    |> Helpers.return_as_tuple()
  end
end

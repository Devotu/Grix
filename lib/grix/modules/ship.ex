defmodule Grix.Ship do
  alias Grix.Helpers.General, as: Helpers
  alias Grix.Helpers.Database
  alias Grix.Ship
  alias Grix.Card

  defstruct id: "", name: "", frame: "", upgrades: [], points: 0

  def generate(name) do
    id = Helpers.generate_guid()
    struct(Ship, [id: id, name: name])
  end


  def generate_from_xws_pilot(%{"upgrades" => upgrade_list, "ship" => frame, "id" => pilot, "points" => points}) do
    upgrades = upgrade_list
      |> Enum.reduce([], fn x, acc -> acc ++ Card.get_or_create_from_xws(x) end)
      |> Enum.map(fn c -> Card.assign_guid(c) end)

    pilot_card = Card.get_or_create_from_xws("pilot", pilot)
      |> Card.assign_guid()


    generate(Database.convert_to_name(pilot))
    |> assign_upgrades(upgrades ++ [pilot_card])
    |> Map.put(:points, points)
    |> Map.put(:ship, frame)
  end

  def generate_from_xws_pilot(%{"ship" => ship, "id" => pilot, "points" => points}) do
    pilot_card = Card.get_or_create_from_xws("pilot", pilot)

    generate(Database.convert_to_name(pilot))
    |> assign_upgrades([pilot_card])
    |> Map.put(:points, points)
    |> Map.put(:ship, ship)
  end


  def assign_upgrades(%Ship{} = ship, upgrades) do
    case upgrades_are_valid(ship, upgrades) do
      :ok ->
        %{ship | :upgrades => upgrades}
      _ ->
        {:error, :invalid_upgrades}
    end
  end


  defp upgrades_are_valid(%Ship{} = _ship, upgrades) when is_list(upgrades) do
    :ok
  end


  defp assign_frame(%Ship{} = ship, upgrades) when is_list(upgrades) do
    {:ok, frame_id} = find_frame(upgrades)
  end


  def find_frame(upgrades) when is_list(upgrades) do
    upgrades
    |> Enum.filter(fn c -> c.type == "pilot" end)
    |> List.first()
    |> Card.find_frame()
  end


  def count_points(%Ship{} = ship) do
    ship.upgrades
    |> Enum.map(&(&1.points))
    |> Enum.sum()
  end


  def persist_ship(%Ship{} = ship, squad_id) do
    match_q = " MATCH \n (sq:Squad), " #OK
    match_cards_q = ship.upgrades #"(pilot:Pilot), (force:Force), (astromech:Astromech), (torpedo:Torpedo)"
      |> Enum.map(&Card.write_persist_match/1)
      |> Enum.join(", ")

    where_q = " WHERE \n sq.id = \"#{squad_id}\" \n AND " #OK
    where_cards_q = ship.upgrades #" AND pilot.id = \"lukeskywalker\" AND force.id = \"brilliantevasion\""
    |> Enum.map(&Card.write_persist_where/1)
    |> Enum.join("\n AND ")

    create_q = " CREATE \n (sq)-[:Includes]->(s:Ship {id:\"#{ship.id}\", name:\"#{ship.name}\", created:TIMESTAMP()}), \n" #OK
    create_cards_q = ship.upgrades #"(s)-[:Use {points: 62}]->(pilot), (s)-[:Use {points: 3}]->(force)"
    |> Enum.map(&Card.write_persist_create/1)
    |> Enum.join("\n, ")

    query = match_q <> match_cards_q <> where_q <> where_cards_q <> create_q <> create_cards_q

    response = Database.run(query)

    case response.stats["nodes-created"] do
      1 -> :ok
      0 -> {:error, :insert_failure}
      _ -> {:error, :unknown_error}
    end
  end
end

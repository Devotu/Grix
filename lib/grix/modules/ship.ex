defmodule Grix.Ship do
  alias Grix.Helpers.General, as: Helpers
  alias Grix.Helpers.Database
  alias Grix.Ship
  alias Grix.Card

  defstruct id: "", name: "", ship: "", upgrades: [], points: 0

  def generate(name) do
    id = Helpers.generate_guid()
    struct(Ship, [id: id, name: name])
  end


  def generate_from_xws_pilot(%{"upgrades" => upgrade_list, "ship" => ship, "id" => pilot, "points" => points}) do
    upgrades = upgrade_list
      |> Enum.reduce([], fn x, acc -> acc ++ Card.get_or_create_from_xws(x) end)
      |> Enum.map(fn c -> Card.assign_guid(c) end)

    pilot_card = Card.get_or_create_from_xws("pilot", pilot)
      |> Card.assign_guid()


    generate(Database.convert_to_name(pilot))
    |> assign_upgrades(upgrades ++ [pilot_card])
    |> Map.put(:points, points)
    |> Map.put(:ship, ship)
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


  def count_points(%Ship{} = ship) do
    ship.upgrades
    |> Enum.map(&(&1.points))
    |> Enum.sum()
  end


  def write_persist_query(%Ship{} = ship) do
    """
      (sq)-[:Includes]->(s:Ship {id:"#{ship.id}", name:"#{ship.name}", created:TIMESTAMP()})
    """
  end
end

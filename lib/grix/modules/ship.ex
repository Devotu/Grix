defmodule Grix.Ship do
  alias Grix.Helpers.General, as: Helpers
  alias Grix.Helpers.Database
  alias Grix.Ship
  alias Grix.Card

  defstruct id: "", name: "", upgrades: [], points: 0

  def generate(name) do
    id = Helpers.generate_guid()
    struct(Ship, [id: id, name: name])
  end


  def generate_from_xws_pilot(%{"upgrades" => upgrade_list, "ship" => pilot}) do
    upgrades = Enum.reduce(upgrade_list, [], fn x, acc -> acc ++ Card.get_or_create_from_xws(x) end)
    pilot_card = Card.get_or_create_from_xws("pilot", pilot)

    ship = generate(Database.convert_to_name(pilot))
    assign_upgrades(ship, upgrades ++ [pilot_card])
  end

  def generate_from_xws_pilot(%{"ship" => pilot}) do
    pilot_card = Card.get_or_create_from_xws("pilot", pilot)
    ship = generate(Database.convert_to_name(pilot))
    assign_upgrades(ship, [pilot_card])
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
end

defmodule Grix.XWS do
  alias Grix.Card
  alias Grix.Ship
  alias Grix.Squad

  def parse(xws_string) do
    Poison.decode(~s(#{xws_string}))
  end

  def is_valid(xws_string) do
    case parse(xws_string) do
      {:error, reason} ->
        IO.inspect(reason, label: "XWS - Parse error parsing: #{xws_string}")
        :false
      _ -> :true
    end
  end


  def update_points(%Squad{} = squad, %{} = points_map) do
    updated_ships = Enum.map(squad.ships, fn s -> set_ship_points(s, points_map) end)
    Map.put(squad, :ships, updated_ships)
  end


  defp set_ship_points(%Ship{} = ship, %{} = points_map) do
    updated_upgrades = Enum.map(ship.upgrades, fn u -> set_upgrade_points(u, points_map) end)
    Map.put(ship, :upgrades, updated_upgrades)
  end


  defp set_upgrade_points(%Card{} = card, %{} = points_map) do
    Map.put(card, :points, points_map[card.guid] |> String.to_integer())
  end


  def translate_squad(%Squad{} = squad) do
    Map.put(squad, :faction, translate_faction(squad.faction))
  end

  defp translate_faction("rebelalliance"), do: "rebel"
  defp translate_faction("galacticempire"), do: "empire"
  defp translate_faction("scumandvillainy"), do: "scum"
  defp translate_faction("resistance"), do: "resistance"
  defp translate_faction("firstorder"), do: "order"
  defp translate_faction("galacticrepublic"), do: "republic"
  defp translate_faction("separatistalliance"), do: "separatist"
end

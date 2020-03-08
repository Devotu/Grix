defmodule Grix.Ship do
  alias Grix.Helpers.General, as: Helpers
  alias Grix.Ship

  defstruct id: "", name: "", upgrades: [], points: 0

  def generate(name) do
    id = Helpers.generate_guid()
    struct(Ship, [id: id, name: name])
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
end

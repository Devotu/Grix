defmodule Grix.Ship do
  alias Grix.Helpers.General, as: Helpers
  alias Grix.Ship

  defstruct id: "", name: "", upgrades: [], points: 0

  def generate(name) do
    id = Helpers.generate_guid()
    struct(Ship, [id: id, name: name])
  end


  def assign_upgrades(%Ship{} = ship, upgrades) do
    %{ship | :upgrades => upgrades}
  end
end

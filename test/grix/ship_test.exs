defmodule Grix.ShipTest do
  use ExUnit.Case
  alias Grix.Ship
  alias Grix.Card

  test "generate Ship" do
    name = "New Ship"
    ship = Ship.generate(name)
    assert %Ship{} = ship
    assert 19 == String.length(ship.id)
    assert name == ship.name
  end

  test "assign upgrades" do
    ship = Ship.generate("The ship")
    {:ok, upgrades} = Card.get(["redsquadronveteran", "crackshot", "r3astromech"])
    upgraded_ship = Ship.assign_upgrades(ship, upgrades)
    IO.inspect(upgraded_ship, label: "ship")
    assert 3 == Enum.count(upgraded_ship.upgrades)
  end
end

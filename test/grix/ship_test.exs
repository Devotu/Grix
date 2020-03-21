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
    assert 3 == Enum.count(upgraded_ship.upgrades)
  end


  test "write query persist" do
    ship_name = "Persisted ship"
    ship = Ship.generate(ship_name)
    {:ok, upgrades} = Card.get(["redsquadronveteran", "crackshot", "r3astromech"])
    {:ok, upgrades} = Card.get(["redsquadronveteran", "crackshot", "r3astromech"])
    upgraded_ship = Ship.assign_upgrades(ship, upgrades)

    query = Ship.write_persist_query(upgraded_ship)

    assert query ==
    """
      (sq)-[:Includes]->(s:Ship {id:"#{ship.id}", name:"#{ship_name}", created:TIMESTAMP()})
    """
  end
end

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
    {:ok, upgrades} = Card.get(["lukeskywalker", "protontorpedoes", "r3astromech"]) #Luke has the frame
    upgraded_ship = Ship.assign_upgrades(ship, upgrades)
    assert 3 == Enum.count(upgraded_ship.upgrades)
    assert "t65xwing" == upgraded_ship.frame
  end


  test "find frame" do
    {:ok, upgrades} = Card.get(["lukeskywalker", "crackshot", "r3astromech"]) #Luke has the frame
    assert {:ok, frame} = Ship.find_frame(upgrades)
    assert "T-65 X-Wing" == frame.name
  end


  test "get ships" do
    {:ok, ships} = Ship.get_ships_in_squad("squad1hash")

    IO.inspect(ships, label: "ships:")

    assert Enum.count(ships) == 3
  end
end

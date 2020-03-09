defmodule Grix.SquadTest do
  use ExUnit.Case
  alias Grix.Squad
  alias Grix.Ship
  alias Grix.Card

  test "create squad" do
    name = "Squad 3"
    faction = "Rebel"
    archetype = "Ace"
    xws = """
    {"key": 1, "value": "valid json"}
    """
    {status, id} = Squad.create(name, faction, archetype, xws)
    assert :ok == status
    assert 19 == String.length(id)
  end

  test "create squad - fail - missing name" do
    name = ""
    faction = "Scum"
    archetype = "Nok"
    xws = """
    {"key": 1, "value": "valid json"}
    """
    assert {:error, :missing_parameter, "name"} == Squad.create(name, faction, archetype, xws)
  end


  test "get Squads" do
    {status, list} = Squad.list()
    assert :ok == status
    assert is_list(list)
  end


  test "get Squad" do
    squad_id = "squad1hash"
    {status, squad} = Squad.get(squad_id)
    assert :ok == status
    assert %Squad{
      id: squad_id,
      name: "First Squad",
      archetype: "Aces",
      faction: "Rebel"
    } == squad
  end


  test "generate squad" do
    name = "Squad 4"
    faction = "Empire"
    archetype = "Swarm"
    xws = """
    {"key": 1, "value": "valid json"}
    """
    {status, squad} = Squad.generate(name, faction, archetype, xws)
    assert :ok == status
    assert %Squad{} = squad
    assert 19 == String.length(squad.id)
    assert name == squad.name
  end

  test "generate squad - faction failure" do
    name = "Squad 4"
    faction = ""
    archetype = "Swarm"
    xws = """
    {"key": 1, "value": "valid json"}
    """
    assert {:error, :missing_parameter, "faction"} = Squad.generate(name, faction, archetype, xws)
  end


  test "assign ships" do
    upgrades = [
      %Card{id: "redsquadronveteran", name: "Red Squadron Veteran", type: "Ship", points: 41},
      %Card{id: "crackshot", name: "Crack shot", type: "Talent", points: 1},
      %Card{id: "protontorpedoes", name: "Proton Torpedoes", type: "Torpedo", points: 13},
    ]

    ships = [
      %Ship{id: "redone", name: "Red One", upgrades: upgrades},
      %Ship{id: "redtwo", name: "Red Two", upgrades: upgrades},
      %Ship{id: "redthree", name: "Red Three", upgrades: upgrades}
    ]

    squad = %Squad{id: "squad5", name: "Squad 5", archetype: "Rebel", faction: "Strike", xws: ""}

    {status, result} = Squad.assign_ships(squad, ships)
    assert :ok == status
    assert 165 == result.points
  end

  test "assign ships - failure to many points" do
    upgrades = [
      %Card{id: "redsquadronveteran", name: "Red Squadron Veteran", type: "Ship", points: 41},
      %Card{id: "crackshot", name: "Crack shot", type: "Talent", points: 1},
      %Card{id: "protontorpedoes", name: "Proton Torpedoes", type: "Torpedo", points: 13},
    ]

    ships = [
      %Ship{id: "redone", name: "Red One", upgrades: upgrades},
      %Ship{id: "redtwo", name: "Red Two", upgrades: upgrades},
      %Ship{id: "redthree", name: "Red Three", upgrades: upgrades},
      %Ship{id: "redfour", name: "Red Four", upgrades: upgrades}
    ]

    squad = %Squad{id: "squad6", name: "Squad 6", archetype: "Rebel", faction: "Strike", xws: ""}

    {status, result} = Squad.assign_ships(squad, ships)
    assert :error == status
    assert :point_limit_exceeded == result
  end
end

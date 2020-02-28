defmodule GrixWeb.SquadTest do
  use ExUnit.Case
  alias Grix.Squad

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
    squad_id = "sq1hash"
    {status, squad} = Squad.get(squad_id)
    assert :ok == status
    assert %Squad{
      id: squad_id,
      name: "First Squad",
      archetype: "Aces",
      faction: "Rebel"
    } == squad
  end
end

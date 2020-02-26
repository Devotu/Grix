defmodule GrixWeb.SquadTest do
  use ExUnit.Case
  alias Grix.Squad

  test "create squad" do
    name = "Squad 3"
    faction = "fReb"
    archetype = "atAce"
    {status, id} = Squad.create(name, faction, archetype)
    assert :ok == status
    assert 19 == String.length(id)
  end

  test "create squad - fail - missing name" do
    name = ""
    faction = "fScm"
    archetype = "atNok"
    assert {:error, :missing_parameter, "name"} == Squad.create(name, faction, archetype)
  end

  test "get Squad" do
    squad_id = "sq1hash"
    assert {:ok, %Squad{id: squad_id, name: "First Squad"}} == Squad.get(squad_id)
  end
end

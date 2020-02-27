defmodule GrixWeb.FactionTest do
  use ExUnit.Case
  alias Grix.Faction

  test "get Factions" do
    {status, list} = Faction.list()
    assert :ok == status
    assert is_list(list)
  end
end

defmodule GrixWeb.ArchetypeTest do
  use ExUnit.Case
  alias Grix.Archetype

  test "get Archetypes" do
    {status, list} = Archetype.list()
    assert :ok == status
    assert is_list(list)
  end
end

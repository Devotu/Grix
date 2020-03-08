defmodule Grix.DatabaseTest do
  use ExUnit.Case
  alias Grix.Helpers.Database

  test "generate in" do
    list = ["one", "two", "three"]
    assert ~s(IN ["one", "two", "three"]) == Database.generate_in(list)
  end

end

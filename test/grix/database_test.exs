defmodule Grix.DatabaseTest do
  use ExUnit.Case
  alias Grix.Helpers.Database

  test "generate in" do
    list = ["one", "two", "three"]
    assert ~s(IN ["one", "two", "three"]) == Database.generate_in(list)
  end

  test "purge numbers" do
    four = "4lom"
    two = "r2d2"
    six = "yv666"

    assert "fourlom" == Database.purgeNumbers(four)
    assert "rtwodtwo" == Database.purgeNumbers(two)
    assert "yvsixsixsix" == Database.purgeNumbers(six)
  end

end

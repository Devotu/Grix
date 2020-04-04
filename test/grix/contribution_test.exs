defmodule Grix.ContributinoTest do
  use ExUnit.Case
  alias Grix.Contribution

  test "add contribution" do
    times = 12
    score_id = "score3hash"
    ship_id = "ship1hash"
    assert {:ok} == Contribution.add(score_id, ship_id, times)
  end

  test "find contribution" do
    {:ok, contribution} = Contribution.find("score1hash", "ship1hash")
    assert 6 == contribution.times
  end
end

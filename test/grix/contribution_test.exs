defmodule Grix.ContributinoTest do
  use ExUnit.Case
  alias Grix.Contribution

  test "add contribution" do
    assert {:ok} == Contribution.add("score3hash", "ship1hash", 12)
  end

  test "add contributions" do
    contributions = [
      %Contribution{ship_id: "ship1hash", times: 10},
      %Contribution{ship_id: "ship2hash", times: 4},
      %Contribution{ship_id: "ship3hash", times: 13}
    ]
    assert {:ok} == Contribution.add("score5hash", contributions)
  end


  test "find contribution" do
    {:ok, contribution} = Contribution.find("score1hash", "ship1hash")
    assert 6 == contribution.times
  end
end

defmodule Grix.ScoreTest do
  use ExUnit.Case
  alias Grix.Score

  test "create score" do
    points = 125
    {status, id} = Score.create("p1hash", "sq1hash", "g3hash", points)
    assert :ok == status
    assert 19 == String.length(id)
  end


  test "get Scores" do
    {status, list} = Score.list()
    assert :ok == status
    assert is_list(list)
    assert 4 <= Enum.count(list)
  end


  test "get Scores by Squad" do
    {status, list} = Score.list("sq1hash")
    assert :ok == status
    assert is_list(list)
    assert 2 <= Enum.count(list)
  end


  test "get Score" do
    score_id = "s1hash"
    {status, score} = Score.get(score_id)
    assert :ok == status
    assert score_id == score.id
    assert is_integer(score.points)
    assert 120 == score.points
  end
end

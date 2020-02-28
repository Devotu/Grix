defmodule Grix.GameTest do
  use ExUnit.Case
  alias Grix.Game

  test "create game" do
    name = "Game 3"
    {status, id} = Game.create("p1hash")
    assert :ok == status
    assert 19 == String.length(id)
  end


  test "get Games" do
    {status, list} = Game.list()
    assert :ok == status
    assert is_list(list)
    assert 1 <= Enum.count(list)
  end


  test "get Games by Squad" do
    {status, list} = Game.list("sq1hash")
    assert :ok == status
    assert is_list(list)
    assert 2 <= Enum.count(list)
  end


  test "get Game" do
    game_id = "g1hash"
    {status, game} = Game.get(game_id)
    assert :ok == status
    assert game_id == game.id
    assert "p1hash" == game.registered
    assert is_integer(game.created)
  end
end

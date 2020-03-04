defmodule Grix.PlayerTest do
  use ExUnit.Case
  alias Grix.Player

  test "login" do
    username = "player1@mail.com"
    password = "Player1"
    assert {:ok, "player1hash"} == Player.login(username, password)
  end

  test "login - fail" do
    username = "player1@mail.com"
    password = "Player2"
    assert {:error, :not_found} == Player.login(username, password)
  end

  test "get Player" do
    user_id = "player1hash"
    assert {:ok, %Player{id: "player1hash", name: "Player 1"}} == Player.get(user_id)
  end
end

defmodule Grix.CardTest do
  use ExUnit.Case
  alias Grix.Card

  test "create Card" do
    assert {:ok, "newcard"} == Card.create("New card", "talent")
  end

  test "get Card" do
    {status, card} = Card.get("crackshot")
    assert :ok == status
    assert "Crack Shot" == card.name
  end

  test "get Cards" do
    {status, cards} = Card.get(["crackshot", "brilliantevasion"])
    assert :ok == status
    assert Enum.count(cards, fn x -> x.name == "Brillian Evasion" end)
    assert Enum.count(cards, fn x -> x.name == "Crack Shot" end)
  end
end

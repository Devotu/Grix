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


  test "write match query" do
    {_status, cards} = Card.get(["crackshot", "brilliantevasion"])
    [c1, c2] = cards

    assert "(#{c1.guid}:Talent)" == Card.write_persist_match(c1)
    assert "(#{c2.guid}:Force)" == Card.write_persist_match(c2)
  end


  test "write and query" do
    {_status, cards} = Card.get(["crackshot", "brilliantevasion"])
    [c1, c2] = cards

    assert  "AND #{c1.guid}.id = \"crackshot\"" == Card.write_persist_and(c1)
    assert  "AND #{c2.guid}.id = \"brilliantevasion\"" == Card.write_persist_and(c2)
  end

  test "write create query" do
    {_status, cards} = Card.get(["crackshot", "brilliantevasion"])
    [c1, c2] = cards
    c1 = Map.put(c1, :points, 1)
    c2 = Map.put(c2, :points, 3)

    assert "(s)-[:Use {points: 1}]->(#{c1.guid})" == Card.write_persist_create(c1)
    assert "(s)-[:Use {points: 3}]->(#{c2.guid})" == Card.write_persist_create(c2)
  end
end

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

  test "get Card does not exist" do
    assert {:error, :not_found} == Card.get("bumpyride")
  end

  test "get Cards" do
    {status, cards} = Card.get(["crackshot", "brilliantevasion"])
    assert :ok == status
    assert Enum.count(cards, fn x -> x.name == "Brillian Evasion" end)
    assert Enum.count(cards, fn x -> x.name == "Crack Shot" end)
  end


  test "write match query" do
    {:ok, c1} = Card.get("crackshot")
    {:ok, c2} = Card.get("brilliantevasion")
    {:ok, c3} = Card.get("redsquadronveteran")

    assert "(#{c1.id}:Talent)" == Card.write_persist_match(c1)
    assert "(#{c2.id}:Force)" == Card.write_persist_match(c2)
    assert "(#{c3.id}:Pilot)" == Card.write_persist_match(c3)
  end


  test "write and query" do
    {:ok, c1} = Card.get("crackshot")
    {:ok, c2} = Card.get("brilliantevasion")

    assert  "#{c1.id}.id = \"crackshot\"" == Card.write_persist_where(c1)
    assert  "#{c2.id}.id = \"brilliantevasion\"" == Card.write_persist_where(c2)
  end

  test "write create query" do
    {_status, cards} = Card.get(["crackshot", "brilliantevasion"])
    [c1, c2] = cards
    c1 = Map.put(c1, :points, 1)
    c2 = Map.put(c2, :points, 3)

    assert "(s)-[:Use {points: 1}]->(#{c1.id})" == Card.write_persist_create(c1)
    assert "(s)-[:Use {points: 3}]->(#{c2.id})" == Card.write_persist_create(c2)
  end


  test "find frame" do
    {:ok, card} = Card.get("lukeskywalker")
    {:ok, frame} = Card.find_frame(card)
    assert "t65xwing" == frame.id
  end


  test "get Cards for Ship" do
    {:ok, cards} = Card.get_cards_for_ship("ship2hash")
    assert Enum.count(cards, fn x -> x.name == "Brillian Evasion" end) == 0
    assert Enum.count(cards, fn x -> x.name == "Crack Shot" && x.points == 1 end) == 1
    assert Enum.count(cards, fn x -> x.name == "Red Squadron Veteran" && x.points == 41 end) == 1
  end
end

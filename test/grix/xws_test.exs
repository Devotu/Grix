defmodule Grix.XWSTest do
  use ExUnit.Case
  alias Grix.XWS

  test "parse" do
    xws = """
    {"description":"","faction":"scumandvillainy","name":"Testsquad","pilots":[{"id":"trandoshanslaver","name":"trandoshanslaver","points":52,"ship":"yv666lightfreighter"},{"id":"bossk","name":"bossk","points":73,"ship":"yv666lightfreighter","upgrades":{"talent":["trickshot"],"crew":["zuckuss","bobafett"],"gunner":["greedo"]}}],"points":125,"vendor":{"yasb":{"builder":"Yet Another Squad Builder 2.0","builder_url":"https://raithos.github.io/","link":"https://raithos.github.io/?f=Scum%20and%20Villainy&d=v8ZsZ200Z155XWWWWWWWY153X133WWW66W16W83WWW&sn=Testsquad&obs="}},"version":"2.0.0"}
    """
    # {status, squad} = XWS.parse(xws)
    # assert :ok == status
    # assert "scumandvillainy" == squad["faction"]
    # assert 2 == Enum.count(squad.ships)

    # [ship_one, ship_two] = squad.ships
    # assert "yv666lightfreighter" == ship_one.hull
    # assert "yv666lightfreighter" == ship_two.hull
    # assert "trickshot" == ship_two.talent
    # assert "greedo" == ship_two.gunner
    # assert 2 == Enum.count(ship_two.crew)

    # [crew_one, crew_two] = ship_two.crew
    # assert "zuckuss" == crew_one
    # assert "bobbafett" == crew_two
  end

end

defmodule Grix.XWSTest do
  use ExUnit.Case
  alias Grix.XWS
  alias Grix.Ship

  test "parse" do
    xws = """
    {"description":"","faction":"scumandvillainy","name":"Testsquad","pilots":[{"id":"trandoshanslaver","name":"trandoshanslaver","points":52,"ship":"yv666lightfreighter"},{"id":"bossk","name":"bossk","points":73,"ship":"yv666lightfreighter","upgrades":{"talent":["trickshot"],"crew":["zuckuss","bobafett"],"gunner":["greedo"]}}],"points":125,"vendor":{"yasb":{"builder":"Yet Another Squad Builder 2.0","builder_url":"https://raithos.github.io/","link":"https://raithos.github.io/?f=Scum%20and%20Villainy&d=v8ZsZ200Z155XWWWWWWWY153X133WWW66W16W83WWW&sn=Testsquad&obs="}},"version":"2.0.0"}
    """
    {status, squad} = XWS.parse(xws)
  end

  test "assign points" do
    xws_squad = %Grix.Squad{
      archetype: "none",
      faction: "rebelalliance",
      guid: "",
      id: "bybi-imfv-vqrm-pqkz",
      name: "Unnamed Squadron",
      points: 70,
      ships: [
        %Grix.Ship{
          id: "viju-qfgf-lvvl-pdtk",
          name: "Greensquadronpilot",
          points: 35,
          ship: "rz1awing",
          upgrades: [
            %Grix.Card{
              guid: "kqgu-afxt-jube-sqmw",
              id: "crackshot",
              name: "Crack Shot",
              points: 0,
              type: "talent"
            },
            %Grix.Card{
              guid: "bzkd-letc-wunf-tbjn",
              id: "predator",
              name: "Predator",
              points: 0,
              type: "talent"
            },
            %Grix.Card{
              guid: "hsqz-umas-uesg-gwko",
              id: "greensquadronpilot",
              name: "Greensquadronpilot",
              points: 0,
              type: "pilot"
            }
          ]
        },
        %Grix.Ship{
          id: "gwnp-odgh-eblu-ygbt",
          name: "Greensquadronpilot",
          points: 35,
          ship: "rz1awing",
          upgrades: [
            %Grix.Card{
              guid: "tils-szfu-kchs-xdnp",
              id: "crackshot",
              name: "Crack Shot",
              points: 0,
              type: "talent"
            },
            %Grix.Card{
              guid: "zsmn-zizy-llel-qdmz",
              id: "daredevil",
              name: "Daredevil",
              points: 0,
              type: "talent"
            },
            %Grix.Card{
              guid: "pysr-hofx-ndld-zbhs",
              id: "greensquadronpilot",
              name: "Greensquadronpilot",
              points: 0,
              type: "pilot"
            }
          ]
        }
      ],
      xws: "{\"description\":\"\",\"faction\":\"rebelalliance\",\"name\":\"Unnamed Squadron\",\"pilots\":[{\"id\":\"greensquadronpilot\",\"name\":\"greensquadronpilot\",\"points\":35,\"ship\":\"rz1awing\",\"upgrades\":{\"talent\":[\"crackshot\",\"predator\"]}},{\"id\":\"greensquadronpilot\",\"name\":\"greensquadronpilot\",\"points\":35,\"ship\":\"rz1awing\",\"upgrades\":{\"talent\":[\"crackshot\",\"daredevil\"]}}],\"points\":70,\"vendor\":{\"yasb\":{\"builder\":\"Yet Another Squad Builder 2.0\",\"builder_url\":\"https://raithos.github.io/\",\"link\":\"https://raithos.github.io/?f=Rebel%20Alliance&d=v8ZsZ200Z52X116W127WY52X116W117W&sn=Unnamed%20Squadron&obs=\"}},\"version\":\"2.0.0\"}"
    }

    point_map = %{
      "_csrf_token" => "OjZhHApYPiwYPQIOMWIPHUNTDhsIVmIsXl0wF0xkqOoTs49Ow5tvGfVV",
      "bzkd-letc-wunf-tbjn" => "4",
      "pysr-hofx-ndld-zbhs" => "34",
      "kqgu-afxt-jube-sqmw" => "3",
      "tils-szfu-kchs-xdnp" => "2",
      "hsqz-umas-uesg-gwko" => "29",
      "zsmn-zizy-llel-qdmz" => "03"
    }

    updated_squad = XWS.update_points(xws_squad, point_map)

    first_ship = List.first(updated_squad.ships)
    first_upgrade = Enum.at(first_ship.upgrades, 0)
    second_upgrade = Enum.at(first_ship.upgrades, 1)
    third_upgrade = Enum.at(first_ship.upgrades, 2)

    IO.inspect(first_ship, label: "first ship: ")

    assert 3 == first_upgrade.points
    assert 4 == second_upgrade.points
    assert 29 == third_upgrade.points
  end

end

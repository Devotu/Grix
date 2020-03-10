defmodule Grix.Squad do
  alias Grix.Helpers.General, as: Helpers
  alias Grix.Helpers.Database
  alias Grix.Squad
  alias Grix.Ship
  alias Grix.XWS

  defstruct id: "", name: "", archetype: "", faction: "", xws: "", points: 0, ships: []


  def generate("", _, _, _), do: {:error, :missing_parameter, "name"}
  def generate(_, "", _, _), do: {:error, :missing_parameter, "faction"}
  def generate(_, _, "", _), do: {:error, :missing_parameter, "archetype"}

  def generate(name, faction, archetype, xws_string) do
    guid = Helpers.generate_guid()
    xws = XWS.parse(xws_string)
    {:ok, %Squad{id: guid, name: name, archetype: archetype, faction: faction, xws: xws}}
  end


  def generate_from_xws(xws_string) when is_bitstring(xws_string) do
    {:ok, xws} = XWS.parse(xws_string)
    {:ok, squad} = generate(xws["name"], xws["faction"], "none", xws_string)
    ships = Enum.map(xws["pilots"], &Ship.generate_from_xws_pilot/1)
    IO.inspect(ships, label: "ships")
    assign_ships(squad, ships)
  end


  def assign_ships(%Squad{} = squad, ships) do
    case ships_are_valid(ships) do
      {:ok, _ships} ->
        squad
        |> Helpers.pipe_update_map(:ships, ships)
        |> Helpers.pipe_update_map(:points, count_points(ships))
        |> Helpers.return_as_tuple()
      {:error, msg} ->
        {:error, msg}
    end
  end

  defp ships_are_valid(ships) when is_list(ships) do
    {:ok, ships}
    |> valid_count()
    |> valid_points()
  end


  def create("", _, _, _), do: {:error, :missing_parameter, "name"}
  def create(_, "", _, _), do: {:error, :missing_parameter, "faction"}
  def create(_, _, "", _), do: {:error, :missing_parameter, "archetype"}

  def create(name, faction, archetype, xws) do

    guid = Helpers.generate_guid()
    safe_xws = Database.to_safe_json(xws)

    query = """
    MATCH
      (at:Archetype), (f:Faction)
    WHERE
      at.id = "#{archetype}"
      AND f.id = "#{faction}"
    CREATE
      (f)<-[:Belongs]-
      (sq:Squad {id:"#{guid}", name:"#{name}", xws:"#{safe_xws}", created:TIMESTAMP()})
      -[:Is]->(at)
    RETURN sq.id AS id;
    """

    Database.create(query, guid)
  end


  def list() do
    query = """
    MATCH
      (f:Faction)<-[:Belongs]-
      (sq:Squad)
      -[:Is]->(at:Archetype)
    RETURN
      {
        id: sq.id,
        name: sq.name,
        archetype: at.name,
        faction: f.name,
        xws: sq.xws
      } AS squad
    """

    Database.get(query)
    |> nodes_to_squads
    |> Helpers.return_as_tuple()
  end


  def get(id) do
    query = """
    MATCH
      (f:Faction)<-[:Belongs]-
      (sq:Squad)
      -[:Is]->(at:Archetype)
    WHERE
      sq.id = "#{id}"
    RETURN
      {
        id: sq.id,
        name: sq.name,
        archetype: at.name,
        faction: f.name,
        xws: sq.xws
      } AS squad
    """

    Database.get(query)
    |> nodes_to_squads
    |> Helpers.return_expected_single
  end


  #Invariants
  defp valid_count({:error, msg}), do: {:error, msg}
  defp valid_count({:ok, ships}) do
    ship_count = Enum.count(ships)
    case ship_count do
      0 -> {:error, :ship_count_invalid}
      1 -> {:error, :ship_count_invalid}
      _ -> {:ok, ships}
    end
  end


  defp valid_points({:error, msg}), do: {:error, msg}
  defp valid_points({:ok, ships}) do
    case count_points(ships) < 200 do
      :false -> {:error, :point_limit_exceeded}
      _ -> {:ok, ships}
    end
  end



  #Helpers
  defp nodes_to_squads(nodes) do
    Enum.map(nodes, &node_to_squad/1)
  end

  defp node_to_squad(node) do
    data_map = Helpers.atomize_keys(node["squad"])
    parsed_data_map = Map.put(data_map, :xws, Database.from_safe_json(data_map.xws))
    struct(Squad, parsed_data_map)
  end


  defp count_points(ships) when is_list(ships) do
    ships
    |> Enum.map(&Ship.count_points/1)
    |> Enum.sum()
  end
end

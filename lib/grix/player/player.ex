defmodule Grix.Player do  
  alias Bolt.Sips, as: Bolt
  alias Grix.Helpers
  alias Grix.Player

  defstruct id: "", name: "" 

  def login(username, password) do
    query = """
    MATCH 
      (p:Player)
    WHERE 
      p.email = "#{username}"
      AND p.password = "#{password}"
    RETURN
      p
    """

    Bolt.query!(Bolt.conn, query)
    |> nodes_to_players
    |> Enum.map(&Helpers.return_id/1)
    |> Helpers.return_expected_single
  end

  def get(id) do
    query = """
    MATCH 
      (p:Player)
    WHERE 
      p.id = "#{id}"
    RETURN
      p
    """

    Bolt.query!(Bolt.conn, query)
    |> nodes_to_players
    |> Helpers.return_expected_single
  end

  #Helpers
  defp nodes_to_players(nodes) do
    Enum.map(nodes, &node_to_player/1)
  end

  defp node_to_player( node ) do
    player_map =
    node["p"].properties
    |> Helpers.atomize_keys

    struct(Player, player_map)
  end
end

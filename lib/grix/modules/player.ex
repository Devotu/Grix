defmodule Grix.Player do
  alias Bolt.Sips, as: Bolt
  alias Grix.Helpers.General, as: Helpers
  alias Grix.Player

  defstruct id: "", name: ""

  def validate_login_credentials(username, password) do
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

  @spec get(any) :: :error | {:error, :invalid_request | :not_found} | {:ok, any}
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


  def list() do
    query = """
    MATCH
      (p:Player)
    RETURN
      p
    """

    Bolt.query!(Bolt.conn, query)
    |> nodes_to_players
    |> Helpers.return_as_tuple()
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

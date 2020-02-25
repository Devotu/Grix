defmodule Grix.Auth do
  import Plug.Conn

  alias Grix.Player

  def init(_opts) do

  end

  def call(conn, _opts) do
    player_id = get_session(conn, :player_id)
    case Player.get(player_id) do
      {:ok, player} ->
        assign(conn, :player, player)
      _ ->
        conn
    end
  end
end

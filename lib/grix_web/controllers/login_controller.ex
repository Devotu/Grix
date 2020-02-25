defmodule GrixWeb.LoginController do
  use GrixWeb, :controller

  alias Grix.Player
  alias Grix.Helpers

  def show(conn, _params) do
    IO.inspect(conn.assigns, label: "assigns - login")
    render(conn, "login.html")
  end

  def login(conn, %{"username" => username, "password" => password}) do
    case Player.login(username, password) do
      {:ok, id} ->
        {:ok, player} = Player.get(id)

        conn
        |> assign(:player, player)
        |> put_session(:player_id, player.id)
        |> IO.inspect(label: "post")
        |> redirect(to: Routes.main_path(conn, :show))
      {:error, msg} ->
        redirect(conn, to: Routes.login_path(conn, :show))
      _ ->
        redirect(conn, to: Routes.login_path(conn, :show))
    end
  end

end

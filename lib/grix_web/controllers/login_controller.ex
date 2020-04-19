defmodule GrixWeb.LoginController do
  use GrixWeb, :controller

  alias Grix.Player

  def show(conn, _params) do
    render(conn, "login.html")
  end

  def login(conn, %{"username" => username, "password" => password}) do
    case Player.validate_login_credentials(username, password) do
      {:ok, id} ->
        {:ok, player} = Player.get(id)

        conn
        |> assign(:player, player)
        |> put_session(:player_id, player.id)
        |> redirect(to: Routes.main_path(conn, :show))
      {:error, :not_found} ->
        conn
        |> put_flash(:error, "Username/password not found")
        |> redirect(to: Routes.login_path(conn, :show))
      _ ->
        conn
        |> put_flash(:error, "Unknown error")
        |> redirect(to: Routes.login_path(conn, :show))
    end
  end

  def logout(conn, _params) do
    conn
    |> assign(:player, nil)
    |> put_session(:player_id, nil)
    |> redirect(to: Routes.login_path(conn, :show))
  end

end

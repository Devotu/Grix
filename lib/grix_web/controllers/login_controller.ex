defmodule GrixWeb.LoginController do
  use GrixWeb, :controller

  alias Grix.Player
  alias Grix.Helpers

  def show(conn, _params) do
    render(conn, "login.html")
  end

  def login(conn, %{"username" => username, "password" => password}) do
    case Player.login(username, password) do
      {:ok, id} -> 
        redirect(conn, to: Routes.main_path(conn, :show))
      {:error, msg} -> 
        redirect(conn, to: Routes.login_path(conn, :show))
      _ ->
        redirect(conn, to: Routes.login_path(conn, :show))
    end
  end

end
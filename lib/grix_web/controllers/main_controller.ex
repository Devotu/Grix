defmodule GrixWeb.MainController do
  use GrixWeb, :controller

  def show(conn, _params) do
    case Map.has_key?(conn.assigns, :player) do
      :true ->
        render(conn, "main.html")
      _ ->
        redirect(conn, to: Routes.login_path(conn, :show))
    end
  end

end

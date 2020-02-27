defmodule GrixWeb.MainController do
  use GrixWeb, :controller

  def show(conn, _params) do
    render(conn, "main.html")
  end

end

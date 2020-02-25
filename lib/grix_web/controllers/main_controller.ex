defmodule GrixWeb.MainController do
  use GrixWeb, :controller

  alias Grix.Player
  alias Grix.Helpers

  def show(conn, _params) do
    IO.inspect(conn.assigns, label: "assigns - main")
    render(conn, "main.html")
  end

end

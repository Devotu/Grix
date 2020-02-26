defmodule GrixWeb.SquadController do
  use GrixWeb, :controller

  def new(conn, _params) do
    render(conn, "new.html")
  end


  def create(conn, params) do
    conn
    |> assign(:squad, %{name: params["name"]})
    |> render("show.html")
  end
end

defmodule GrixWeb.SquadController do
  use GrixWeb, :controller

  alias Grix.Squad

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def index(conn, _params) do
    case Squad.list() do
      {:ok, list} ->
        conn
        |> assign(:squads, list)
        |> render("list.html")
      _ ->
        conn
        |> put_flash(:error, "?")
        |> redirect(to: Routes.main_path(conn, :show))
    end
  end

  def show(conn, params) do
    case Squad.get(params["id"]) do
      {:ok, squad} ->
        conn
        |> assign(:squad, squad)
        |> render("show.html")
      {:error, :not_found} ->
        conn
        |> put_flash(:error, "No such squad")
        |> render("new.html")
      _ ->
        conn
        |> put_flash(:error, "?")
        |> render("new.html")
    end
  end


  def create(conn, params) do
    case Squad.create(params["name"], params["faction"], params["archetype"]) do
      {:ok, id} ->
        {:ok, squad} = Squad.get(id)
        conn
        |> assign(:squad, squad)
        |> render("show.html")
      {:error, _kind, msg} ->
        conn
        |> put_flash(:error, msg)
        |> render("new.html")
      _ ->
        :error
    end
  end
end

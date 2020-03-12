defmodule GrixWeb.Router do
  use GrixWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Grix.Auth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", GrixWeb do
    pipe_through :browser

    get "/", MainController, :show

    get "/login", LoginController, :show
    post "/login", LoginController, :login

    get "/main", MainController, :show

    get "/squads", SquadController, :index
    get "/squads/new", SquadController, :new
    get "/squads/new/xws", SquadController, :new_from_xws
    get "/squads/specify", SquadController, :specify
    get "/squads/:id", SquadController, :show
    post "/squads", SquadController, :create
    post "/squads/xws", SquadController, :generate_from_xws

    get "/games/new", GameController, :new
    get "/games/:id", GameController, :show
    post "/games", GameController, :create
  end
end

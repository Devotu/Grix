defmodule GrixWeb.Router do
  use GrixWeb, :router

  # alias Grix.Auth

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

    get "/", LoginController, :show

    get "/login", LoginController, :show
    post "/login", LoginController, :login

    get "/main", MainController, :show
  end
end

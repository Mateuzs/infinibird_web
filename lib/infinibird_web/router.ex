defmodule InfinibirdWeb.Router do
  use InfinibirdWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :authenticate do
    plug InfinibirdWeb.Plugs.Authenticate
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", InfinibirdWeb do
    pipe_through :browser

    get "/", HomeController, :index
    get "/login", LoginController, :index
    post "/login", LoginController, :create
    post "/logout", LoginController, :delete
    get "/charts", ChartsController, :index
    get "/map", MapController, :index
  end

  scope "/", InfinibirdWeb do
    pipe_through :authenticate
  end

  # Other scopes may use custom stacks.
  # scope "/api", InfinibirdWeb do
  #   pipe_through :api
  # end
end

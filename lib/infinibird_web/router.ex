defmodule InfinibirdWeb.Router do
  use InfinibirdWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug InfinibirdWeb.Plugs.SetCurrentUser
  end

  pipeline :auth do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug InfinibirdWeb.Plugs.SetCurrentUser
    plug InfinibirdWeb.Plugs.AuthenticateUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", InfinibirdWeb do
    pipe_through :browser
    get "/login", LoginController, :index
    post "/login", LoginController, :create
    post "/logout", LoginController, :delete
  end

  scope "/", InfinibirdWeb do
    pipe_through :auth
    get "/", HomeController, :index
    get "/charts", ChartsController, :index
    get "/map", MapController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", InfinibirdWeb do
  #   pipe_through :api
  # end
end

defmodule RequestPot.Router do
  use RequestPot.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RequestPot do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  forward "/pot/", RequestPot.RequestHandler


  # Other scopes may use custom stacks.
  # scope "/api", RequestPot do
  #   pipe_through :api
  # end
end

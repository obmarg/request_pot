defmodule RequestPot.Router do
  use RequestPot.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_user_token
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Plug.Parsers,
      parsers: [:json],
      pass: ["*/*"],
      json_decoder: Poison
  end

  scope "/", RequestPot do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api/v1", RequestPot do
    pipe_through :api

    resources "/pots", PotController, only: [:create, :show]
    resources "/pots/:pot_id/requests", RequestController, only: [:index, :show]

    # Also expose "pots" through "bins" for requestb.in compatability.
    resources "/bins", PotController, only: [:create, :show]
    resources "/bins/:pot_id/requests", RequestController, only: [:index, :show]
  end

  forward "/pot/", RequestPot.RequestHandler

  defp put_user_token(conn, _) do
    token = Phoenix.Token.sign(
      conn, "user", Plug.Conn.get_session(conn, :user_id)
    )
    assign(conn, :user_token, token)
  end

end

defmodule RequestPot.RequestController do
  use RequestPot.Web, :controller

  alias RequestPot.{PotServer}

  def index(conn, %{"pot_id" => pot_id}) do
    case PotServer.exists?(pot_id) do
      true ->
        requests = PotServer.requests(pot_id)
        render(conn, "index.json", requests: requests)
      false ->
        conn
        |> put_status(:not_found)
        |> render(RequestPot.ErrorView, "404.json")
    end
  end

  def show(conn, %{"id" => id, "pot_id" => pot_id}) do
    # TODO: Implement this...
  end
end

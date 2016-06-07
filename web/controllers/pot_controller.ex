defmodule RequestPot.PotController do
  use RequestPot.Web, :controller

  alias RequestPot.{PotServer, PotSupervisor}

  def create(conn, params) do
    private = Map.get(params, "private", false)

    case PotSupervisor.add_pot(private) do
      {:ok, pot} ->
        conn
        |> put_status(:ok)
        |> render("show.json", pot: pot)
      {:error, _} ->
        conn
        |> put_status(:internal_server_error)
        |> render(RequestPot.ErrorView, "500.json")
    end
  end

  def show(conn, %{"id" => id}) do
    require Logger
    Logger.info("ID => #{id}")
    case PotServer.exists?(id) do
      true ->
        pot = PotServer.info(id)
        render(conn, "show.json", pot: pot)
      false ->
        conn
        |> put_status(:not_found)
        |> render(RequestPot.ErrorView, "404.json")
    end
  end
end

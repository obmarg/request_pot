defmodule RequestPot.RequestHandler do
  # Handles incoming requests to a request pot.
  # This is not your standard phoenix controller, as we need to do something a
  # little differently.
  use Plug.Router

  plug :match
  plug :dispatch

  match "/:pot_id" do
    send_resp(conn, 200, "done")
  end

  match _ do
    send_resp(conn, 404, "No Pot Found")
  end
end

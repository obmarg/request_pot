defmodule RequestPot.RequestHandler do
  # Handles incoming requests to a request pot.
  # This is not your standard phoenix controller, as we need to do something a
  # little differently.
  use Plug.Router

  alias RequestPot.{Request, PotServer}

  plug :match
  plug :dispatch

  match "/:pot_id" do
    {:ok, body, conn} = read_body(conn)
    body_params =
      case conn.body_params do
        %Plug.Conn.Unfetched{} -> %{}
        body_params -> body_params
      end

    req = %Request{
      method: conn.method,
      content_type: conn |> get_req_header("content-type") |> List.first,
      headers: Map.new(conn.req_headers),
      path: "/" <> Enum.join(conn.path_info),
      query_string: Map.new(conn.query_params),
      id: conn |> get_resp_header("x-request-id") |> List.first,
      body_params: body_params,
      body: body,
      remote_addr: peer_to_string(conn.peer),
      time: :erlang.system_time(:seconds),
    }

    case PotServer.exists?(pot_id) do
      true ->
        :ok = PotServer.incoming_request(pot_id, req)
        send_resp(conn, 200, "done")
      false ->
        send_resp(conn, 404, "No such pot!")
    end
  end

  match _ do
    send_resp(conn, 404, "No Pot Found")
  end

  defp peer_to_string({{a, b, c, d}, _port}) do
    "#{a}.#{b}.#{c}.#{d}"
  end
end

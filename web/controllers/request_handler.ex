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

    content_type = conn |> get_req_header("content-type") |> List.first

    req = %Request{
      method: conn.method,
      content_type: content_type,
      headers: Map.new(conn.req_headers),
      path: "/" <> Enum.join(conn.path_info),
      query_string: Map.new(conn.query_params),
      id: conn |> get_resp_header("x-request-id") |> List.first,
      form_data: body_params,
      json_data: maybe_parse_json(content_type, body),
      body: body,
      remote_addr: ip_to_string(conn.remote_ip),
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

  defp ip_to_string({a, b, c, d}) do
    "#{a}.#{b}.#{c}.#{d}"
  end

  @spec maybe_parse_json(String.t, <<>>) :: Poison.Parser.t | nil
  defp maybe_parse_json(nil, _), do: nil
  defp maybe_parse_json(content_type, body) do
    [type, subtype] = String.split(content_type, "/")
    if subtype == "json" or String.ends_with?(subtype, "+json") do
      case Poison.decode(body) do
        {:ok, val} -> val
        _ -> nil
      end
    else
      nil
    end
  end
end

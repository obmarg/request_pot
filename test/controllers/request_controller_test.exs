defmodule RequestPot.RequestControllerTest do
  use RequestPot.ConnCase

  alias RequestPot.{PotInfo, PotServer, Request}

  @pot_name "request_controller_test_pot"
  @requests [%Request{method: "GET"}, %Request{method: "POST"}]

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  setup do
    {:ok, _pid} = @pot_name |> PotInfo.from_name |> PotServer.start_link
    @requests |> Enum.map(&PotServer.incoming_request @pot_name, &1)

    {:ok, %{}}
  end

  test "can get all requests from index", %{conn: conn} do
    conn = get conn, request_path(conn, :index, @pot_name)
    resp = json_response(conn, 200)
    assert length(resp) == 2
    assert_request Enum.at(resp, 0), Enum.at(@requests, 1)
    assert_request Enum.at(resp, 1), Enum.at(@requests, 0)
  end

  test "index 404s on missing pot", %{conn: conn} do
    conn = get conn, request_path(conn, :index, "missing_pot")
    assert json_response(conn, 404)["error"]
  end

  test "can get a single request from show", %{conn: conn} do
    # TODO: Implement
  end

  test "show 404s on missing pot", %{conn: conn} do
    # TODO: Implement
  end

  test "show 404s on missing request", %{conn: conn} do
    # TODO: Implement
  end

  defp assert_request(api_request, expected_request) do
    for {k, v} <- api_request do
      assert Map.get(expected_request, String.to_existing_atom(k)) == v
    end
  end
end

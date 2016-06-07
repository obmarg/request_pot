defmodule RequestPot.RequestHandlerTest do
  use RequestPot.ConnCase

  alias RequestPot.{PotServer, PotInfo}

  setup do
    name = "test_pot"

    {:ok, _pid} = PotServer.start_link(
      %PotInfo{name: name}
    )

    {:ok, %{name: name}}
  end

  test "GET /pot/:name", %{conn: conn, name: name} do
    conn = get conn, "/pot/#{name}"
    assert conn.status == 200

    assert_request name, method: "GET"
  end

  test "GET /pot/:name?some=query&string=args", %{conn: conn, name: name} do
    conn = get conn, "/pot/#{name}?some=query&string=args"
    assert conn.status == 200
    assert_request name, query_string: %{"some" => "query", "string" => "args"}
  end

  test "GET /pot/:name with headers", %{conn: conn, name: name} do
    conn =
      conn
      |> put_req_header("x-test-header", "test")
      |> get("/pot/#{name}")
    assert conn.status == 200
    assert_request name, headers: %{"x-test-header" => "test"}
  end

  test "POST /pot/:name", %{conn: conn, name: name} do
    conn = post conn, "/pot/#{name}"
    assert conn.status == 200
    assert_request name, method: "POST"
  end

  test "POST /pot/:name with json", %{conn: conn, name: name} do
    conn =
      conn
      |> put_req_header("content-type", "application/json")
      |> post("/pot/#{name}", Poison.encode!(%{"test" => "data"}))

    assert conn.status == 200
    assert_request name,
      method: "POST",
      headers: %{"content-type" => "application/json"},
      content_type: "application/json",
      body_params: %{"test" => "data"}
  end

  test "POST /pot/:name with raw data", %{conn: conn, name: name} do
    conn =
      conn
      |> put_req_header("content-type", "text/text")
      |> post("/pot/#{name}", "test_data")

    assert conn.status == 200
    assert_request name,
      method: "POST",
      headers: %{"content-type" => "text/text"},
      content_type: "text/text",
      body: "test_data"
  end

  test "POST /pot/:name with form data", %{conn: conn, name: name} do
    conn =
      conn
      |> put_req_header("content-type", "application/x-www-form-urlencoded")
      |> post("/pot/#{name}", "form=data&something=other")

    assert conn.status == 200
    assert_request name,
      method: "POST",
      headers: %{"content-type" => "application/x-www-form-urlencoded"},
      content_type: "application/x-www-form-urlencoded",
      body_params: %{"form" => "data", "something" => "other"}
  end

  test "PUT /pot/:name", %{conn: conn, name: name} do
    conn = put conn, "/pot/#{name}"
    assert conn.status == 200
    assert_request name, method: "PUT"
  end

  test "DELETE /pot/:name", %{conn: conn, name: name} do
    conn = delete conn, "/pot/#{name}"
    assert conn.status == 200
    assert_request name, method: "DELETE"
  end

  test "GET /pot", %{conn: conn} do
    conn = get conn, "/pot"
    assert conn.status == 404
  end

  defp assert_request(pot_name, values) do
    [request] = PotServer.requests(pot_name)

    default_values = %{
      method: "GET",
      content_type: nil,
      path: "/" <> pot_name,
      query_string: %{},
      body_params: %{},
      body: ""
    }

    assert request.id
    for {k, v} <- Map.merge(default_values, Map.new(values)) do
      assert Map.get(request, k) == v
    end
  end
end

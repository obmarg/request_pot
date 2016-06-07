defmodule RequestPot.PotControllerTest do
  use RequestPot.ConnCase

  alias RequestPot.{PotInfo, PotServer, PotSupervisor}
  @valid_attrs %{name: "some content", private: true}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "creates a new public pot on post", %{conn: conn} do
    conn = post conn, pot_path(conn, :create)
    resp = json_response(conn, 200)

    assert resp["request_count"] == 0
    assert resp["private"] == false
    assert resp["name"]
    assert PotServer.exists?(resp["name"])
  end

  test "creates a new private pot on post", %{conn: conn} do
    conn = post conn, pot_path(conn, :create), private: true
    resp = json_response(conn, 200)

    assert resp["request_count"] == 0
    assert resp["private"] == true
    assert resp["name"]
    assert PotServer.exists?(resp["name"])
  end

  test "404s on get for missing pot", %{conn: conn} do
    conn = get conn, pot_path(conn, :show, "nope")
    assert json_response(conn, 404)["error"]
  end

  test "returns an existing pot on get", %{conn: conn} do
    {:ok, pot_info} = PotSupervisor.add_pot(false)

    conn = get conn, pot_path(conn, :show, pot_info.name)
    resp = json_response(conn, 200)
    assert resp["name"] == pot_info.name
    assert resp["private"] == false
    assert resp["request_count"] == 0
  end
end

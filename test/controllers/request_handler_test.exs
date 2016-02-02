defmodule RequestPot.RequestHandlerTest do
  use RequestPot.ConnCase

  test "GET /pot/abcd", %{conn: conn} do
    conn = get conn, "/pot/abcd"
    assert conn.status == 200
  end

  test "POST /pot/abcd", %{conn: conn} do
    conn = post conn, "/pot/abcd"
    assert conn.status == 200
  end

  test "PUT /pot/abcd", %{conn: conn} do
    conn = put conn, "/pot/abcd"
    assert conn.status == 200
  end

  test "DELETE /pot/abcd", %{conn: conn} do
    conn = delete conn, "/pot/abcd"
    assert conn.status == 200
  end

  test "GET /pot", %{conn: conn} do
    conn = get conn, "/pot"
    assert conn.status == 404
  end
end

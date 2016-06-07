defmodule RequestPot.PotServerTest do
  use ExUnit.Case

  alias RequestPot.{PotInfo, PotServer}

  @server_name "test_server"
  @server_info %PotInfo{name: @server_name}

  setup do
    {:ok, _pid} = PotServer.start_link(@server_info)

    {:ok, %{}}
  end

  test "PotServer can check if active server exists" do
    assert PotServer.exists?(@server_name)
  end

  test "PotServer can check if inactive server exists" do
    refute PotServer.exists?("missing_server")
  end

  test "pot server can return its info" do
    assert PotServer.info(@server_name) == @server_info
  end

  test "pot server can store incoming requests" do
    PotServer.incoming_request(@server_name, :test1)
    PotServer.incoming_request(@server_name, :test2)
    assert PotServer.requests(@server_name) == [:test2, :test1]
  end
end

defmodule RequestPot.PotServerTest do
  use ExUnit.Case

  alias RequestPot.{PotInfo, PotServer}

  @server_name "test_server"
  @server_info %PotInfo{name: @server_name}

  setup do
    {:ok, _pid} = @server_name |> PotInfo.from_name |> PotServer.start_link

    {:ok, %{}}
  end

  test "PotServer can check if active server exists" do
    assert PotServer.exists?(@server_name)
  end

  test "PotServer can check if inactive server exists" do
    refute PotServer.exists?("missing_server")
  end

  test "pot server can return its info" do
    info = PotServer.info(@server_name)
    assert info.name == @server_name
    assert info.request_count == 0
    assert info.time_created
    refute info.private
  end

  test "pot server can store incoming requests" do
    PotServer.incoming_request(@server_name, :test1)
    PotServer.incoming_request(@server_name, :test2)
    assert PotServer.requests(@server_name) == [:test2, :test1]
  end
end

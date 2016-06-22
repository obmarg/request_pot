defmodule RequestPot.PotChannelTest do
  use RequestPot.ChannelCase

  alias RequestPot.{PotChannel, PotServer, PotInfo, Request}

  @pot_name "pot_channel_test_pot"
  @test_request %Request{method: "GET"}

  setup do
    {:ok, _pid} = @pot_name |> PotInfo.from_name |> PotServer.start_link
    PotServer.incoming_request(@pot_name, @test_request)

    user_id = UUID.uuid4

    {:ok, _, lobby_socket} =
      socket("user_id", %{user: user_id})
      |> subscribe_and_join(PotChannel, "pot:lobby")

    {:ok, _, pot_socket} =
      socket("user_id", %{user: user_id})
      |> subscribe_and_join(PotChannel, "pot:#{@pot_name}")

    {:ok, socket: lobby_socket, pot_socket: pot_socket}
  end

  test "create_pot on lobby creates a pot", %{socket: socket} do
    ref = push socket, "create_pot", %{}

    assert_reply ref, :ok, %{"pot" => pot}
    assert pot.request_count == 0
    assert pot.private == false
    assert pot.name
    assert PotServer.exists?(pot.name)
  end

  test "create_pot can create a private pot", %{socket: socket} do
    ref = push socket, "create_pot", %{"private" => true}

    assert_reply ref, :ok, %{"pot" => pot}
    assert pot.request_count == 0
    assert pot.private == true
    assert pot.name
    assert PotServer.exists?(pot.name)
  end

  test "create_pot outwith lobby does nothing", %{pot_socket: socket} do
    ref = push socket, "create_pot", %{}
    refute_reply ref, :ok, %{"pot" => pot}
  end

  test "can't join channel for missing pot" do
    assert {:error, %{reason: "missing_pot"}} =
      socket("user_id", %{user: UUID.uuid4})
      |> subscribe_and_join(PotChannel, "pot:missing")
  end

  test "incoming_request broadcasts to all pot members", %{pot_socket: socket} do
    PotChannel.incoming_request(@pot_name, %{test: "test"})
    assert_broadcast "incoming_request", %{test: "test"}
  end

  test "sends a set_request message on pot channel join", %{pot_socket: socket} do
    assert_push "set_requests", %{requests: [@test_request]}
  end
end

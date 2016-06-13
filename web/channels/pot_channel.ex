defmodule RequestPot.PotChannel do
  use RequestPot.Web, :channel

  require Logger

  alias RequestPot.{PotSupervisor, PotServer}

  @doc """
  Broadcasts a new request to anyone in that pots channel.
  """
  def incoming_request(pot_name, request) do
    RequestPot.Endpoint.broadcast "pot:#{pot_name}", "incoming_request", request
  end

  def join("pot:lobby", payload, socket) do
    send self, :after_lobby_join
    {:ok, socket}
  end

  def join("pot:" <> pot_name, payload, socket) do
    if PotServer.exists?(pot_name) do
      if authorized?(pot_name, socket.assigns[:user_id]) do
        send self, {:after_pot_join, pot_name}
        {:ok, socket}
      else
        {:error, %{reason: "unauthorized"}}
      end
    else
      {:error, %{reason: "missing_pot"}}
    end
  end

  def handle_in("create_pot", payload, %{topic: "pot:lobby"} = socket) do
    private = Map.get(payload, "private", false)

    case PotSupervisor.add_pot(private) do
      {:ok, pot} ->
        {:reply, {:ok, %{"pot" => pot}}, socket}
      {:error, _} ->
        {:reply, :error}
    end
  end

  def handle_in("create_pot", _payload, socket) do
    {:noreply, socket}
  end

  # This is invoked every time a notification is being broadcast
  # to the client. The default implementation is just to push it
  # downstream but one could filter or change the event.
  def handle_out(event, payload, socket) do
    push socket, event, payload
    {:noreply, socket}
  end

  # This passes existing requests to a client that has just joined.
  def handle_info({:after_pot_join, pot_name}, socket) do
    push socket, "set_requests", %{requests: PotServer.requests(pot_name)}
    {:noreply, socket}
  end

  # This should pass existing pots to a client that has just joined.
  def handle_info(:after_lobby_join, socket) do
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(pot_name, user_id) do
    true
  end
end

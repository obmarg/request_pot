defmodule RequestPot.UserSocket do
  use Phoenix.Socket

  ## Channels
  channel "pot:*", RequestPot.PotChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket
  # transport :longpoll, Phoenix.Transports.LongPoll

  # Max token age of 2 weeks.
  @max_age 1209600

  # Socket params are passed from the client and can
  # be used to verify and authenticate a user. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :user_id, verified_user_id)}
  #
  # To deny connection, return `:error`.
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.
  def connect(%{"token" => token}, socket) do
    case Phoenix.Token.verify(socket, "user", token, max_age: @max_age) do
      {:ok, user_id} ->
        {:ok, assign(socket, :user, user_id)}
      {:error, reason} ->
        :error
    end
  end

  def connect(_params, socket) do
    # If users don't provide a token, let them in anyway with a random UUID.
    # Tokens are relatively trivial to get from the initial HTML, so there's little
    # point in enforcing them.
    {:ok, assign(socket, :user, UUID.uuid4)}
  end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "users_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     RequestPot.Endpoint.broadcast("users_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  def id(_socket), do: nil
end

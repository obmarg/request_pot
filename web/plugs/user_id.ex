defmodule RequestPot.Plugs.UserID do
  @moduledoc """
  Makes sure every session contains a user id.
  """

  @behaviour Plug
  import Plug.Conn, only: [get_session: 2, put_session: 3, fetch_session: 1]

  def init(config), do: nil

  def call(conn, config) do
    conn = fetch_session(conn)
    if get_session(conn, :user_id) do
      conn
    else
      put_session(conn, :user_id, UUID.uuid4)
    end
  end
end

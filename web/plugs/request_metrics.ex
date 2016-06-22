defmodule RequestPot.Plugs.RequestMetrics do
  @moduledoc """
  A plug that records response time & count using Elixometer.
  """
  use Elixometer

  @behaviour Plug
  import Plug.Conn, only: [register_before_send: 2]

  def init(config), do: nil

  def call(conn, config) do
    before_time = :os.timestamp()

    register_before_send conn, fn conn ->
      after_time = :os.timestamp()
      diff = :timer.now_diff after_time, before_time

      Elixometer.update_histogram("resp.time", diff)
      Elixometer.update_spiral("resp.count", 1)

      conn
    end
  end
end

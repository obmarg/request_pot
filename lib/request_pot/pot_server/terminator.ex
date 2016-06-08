defmodule RequestPot.PotServer.Terminator do
  use GenServer
  require Logger

  @ttl_secs 60 * 60 * 12

  def start_link(pid, info) do
    GenServer.start_link(__MODULE__, {pid, info})
  end

  def init({pid, info}) do
    units_per_second = :erlang.convert_time_unit(1, :seconds, :native)
    secs_since_start = (:erlang.monotonic_time() - info.time_created) / units_per_second
    secs_remaining = @ttl_secs - secs_since_start
    secs_remaining = if secs_remaining < 0, do: 0, else: secs_remaining

    timeout = round(secs_remaining * 1000)
    {:ok, {pid, info}, timeout}
  end

  def handle_info(:timeout, {pid, info}) do
    Logger.debug("Shutting down server for pot #{info.name}")
    GenServer.stop(pid)
    {:noreply, nil}
  end
end

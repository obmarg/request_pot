defmodule RequestPot.PotServer do
  @moduledoc """
  Stores all the requests for a pot.

  Shuts itself down after a certain period of time.
  """
  use GenServer

  alias RequestPot.PotInfo

  def info(name) do
    name |> proc_name |> GenServer.call(:get_info)
  end

  def exists?(name) do
    name
    |> gproc_name
    |> :gproc.lookup_pids
    |> (case do
         [] -> false
         _  -> true
       end)
  end

  def start_link(info) do
    GenServer.start_link(__MODULE__, info, name: proc_name(info))
  end

  def init(info) do
    {:ok, %{starting_info: info, requests: []}}
  end

  def handle_call(:get_info, _from, state) do
    %{starting_info: starting_info, requests: requests} = state

    {:reply, %{starting_info | request_count: length(requests)}, state}
  end

  defp proc_name(%PotInfo{name: name}) do
    proc_name(name)
  end

  defp proc_name(name) when is_binary(name) do
    {:via, :gproc, gproc_name(name)}
  end

  defp gproc_name(name) do
    {:n, :l, "pot.#{name}"}
  end
end

defmodule RequestPot.PotServer do
  @moduledoc """
  Stores all the requests for a pot.

  Shuts itself down after a certain period of time.
  """
  use GenServer

  alias RequestPot.PotInfo

  def info(name) do
    call(name, :get_info)
  end

  def requests(name) do
    call(name, :get_requests)
  end

  def incoming_request(name, request) do
    call(name, {:incoming_request, request})
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

  def handle_call(:get_requests, _from, state) do
    {:reply, state.requests, state}
  end

  def handle_call({:incoming_request, request}, _from, state) do
    requests = state.requests

    {:reply, :ok, %{state | requests: [request | requests]}}
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

  defp call(name, value) do
    name |> proc_name |> GenServer.call(value)
  end
end

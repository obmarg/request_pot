defmodule RequestPot.PotSupervisor do
  @moduledoc """
  A simple one for one supervisor for our pots.
  """

  alias RequestPot.{PotServer, PotInfo}

  @doc false
  def start_link(opts \\ [name: __MODULE__]) do
    import Supervisor.Spec

    children = [worker(PotServer, [], restart: :transient)]

    Supervisor.start_link(
      children, Keyword.merge(opts, strategy: :simple_one_for_one)
    )
  end

  @doc false
  @spec add_pot(boolean) :: {:ok, PotInfo.t} | {:error, atom}
  def add_pot(private, pid \\ __MODULE__) do
    info = %PotInfo{
      name: new_pot_name,
      private: private,
      time_created: :erlang.monotonic_time()
    }
    case Supervisor.start_child(__MODULE__, [info]) do
      {:ok, child} -> {:ok, info}
      _ -> {:error, :unknown}
    end
  end

  defp new_pot_name do
    # TODO: Could definitely have friendlier names...
    8 |> :crypto.strong_rand_bytes |> Base.encode64
  end
end

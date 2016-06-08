defmodule RequestPot.PotInfo do
  @moduledoc """
  Describes a single request pot.
  """
  use RequestPot.Web, :model

  defstruct [name: nil, private: false, time_created: nil, request_count: 0]

  @type t :: %__MODULE__{
    name: String.t,
    private: boolean,
    time_created: number,
    request_count: number
  }

  @moduledoc """
  Constructs a PotInfo from a name.
  """
  def from_name(name) do
    %__MODULE__{name: name, time_created: :erlang.monotonic_time()}
  end
end

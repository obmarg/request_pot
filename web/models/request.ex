defmodule RequestPot.Request do
  @moduledoc """
  A Request that has been received by a Pot.
  """

  defstruct [
    :method, :content_type, :headers, :path, :query_string, :id, :form_data,
    :json_data, :body, :remote_addr, :time, :content_length
  ]

  @type t :: %__MODULE__{
    method: String.t,
    content_type: String.t | nil,
    headers: %{String.t => String.t},
    path: String.t,
    query_string: %{String.t => String.t},
    id: String.t,
    form_data: %{String.t => String.t},
    json_data: %{String.t => String.t},
    body: String.t,
    remote_addr: String.t,
    time: float,
  }
end

defmodule HomeHub.Daikin.Supervisor do
  @moduledoc false
  use Supervisor
  require Logger

  @name __MODULE__

  def start_link(opts), do: Supervisor.start_link(@name, opts, name: @name)

  @impl true
  def init(opts) do
    children = [
      {DaikinOne.TokenCache, []},
      {DaikinOne.DeviceServer, opts}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end

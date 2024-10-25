defmodule HomeHub.Thermostat.Supervisor do
  @moduledoc false
  use Supervisor
  require Logger
  alias HomeHub.Thermostat

  @name __MODULE__

  def start_link(opts), do: Supervisor.start_link(@name, opts, name: @name)

  @impl true
  def init(opts) do
    children =
      [
        {Phoenix.PubSub, name: Thermostat.PubSub},
        Keyword.fetch!(opts, :sensor_config),
        Keyword.fetch!(opts, :io_config),
        {Thermostat.PID, Keyword.get(opts, :pid_settings, [])},
        {Thermostat, Keyword.get(opts, :settings, [])}
      ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end

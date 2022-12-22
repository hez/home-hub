defmodule HomeHub.Thermostat.PID.PIDEx do
  @moduledoc """
  PID implementation using the PIDex library
  """
  @behaviour HomeHub.Thermostat.PID
  use Supervisor
  alias HomeHub.Thermostat.PID

  @default_pid_settings %Pidex{
    kP: 1.1,
    kI: 1.0,
    kD: 0.001,
    min_point: -25.0,
    max_point: 10.0,
    ts_factor: 30_000.0
  }

  @impl PID
  def start_link(opts), do: Supervisor.start_link(__MODULE__, opts, name: __MODULE__)

  @impl Supervisor
  def init(opts) do
    children = [
      {Pidex.PdxServer,
       settings: Keyword.get(opts, :pid_settings, @default_pid_settings), ts_unit: :millisecond}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  @impl PID
  def value, do: Pidex.PdxServer.output(pidex_pid())

  @impl PID
  def update_set_point(new_point), do: Pidex.PdxServer.set(pidex_pid(), set_point: new_point)

  @impl PID
  def output(temp) do
    Pidex.PdxServer.update_async(pidex_pid(), temp)
    value()
  end

  defp pidex_pid, do: Process.whereis(Pidex.PdxServer)
end

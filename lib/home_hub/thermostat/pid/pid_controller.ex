defmodule HomeHub.Thermostat.PID.PIDController do
  @behaviour HomeHub.Thermostat.PID
  use Agent
  alias HomeHub.Thermostat.PID

  @default [
    # setpoint: 0.0,
    kp: 0.2,
    ki: 0.1,
    # kd: 0.0
    # action: :direct,
    output_limits: {-5.0, 5.0}
  ]

  @impl PID
  def start_link(settings) do
    settings = Keyword.get(settings, :pid_settings, @default)
    Agent.start_link(fn -> PidController.new(settings) end, name: __MODULE__)
  end

  @impl PID
  def value, do: Agent.get(__MODULE__, & &1)

  @impl PID
  def update_set_point(new_point),
    do: Agent.update(__MODULE__, &PidController.set_setpoint(&1, new_point))

  @impl PID
  def output(temp) do
    {:ok, output, state} = PidController.output(temp, value())
    Agent.update(__MODULE__, fn _ -> state end)
    output
  end
end

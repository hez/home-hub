defmodule HomeHub.Thermostat.PID do
  use Agent

  @default [
    # setpoint: 0.0,
    kp: 0.2,
    ki: 0.1,
    # kd: 0.0
    # action: :direct,
    output_limits: {-5.0, 5.0}
  ]

  def start_link(opts \\ []) do
    opts = Keyword.merge(@default, opts)
    Agent.start_link(fn -> PidController.new(opts) end, name: __MODULE__)
  end

  def value, do: Agent.get(__MODULE__, & &1)

  def update_set_point(new_point),
    do: Agent.update(__MODULE__, &PidController.set_setpoint(&1, new_point))

  def output(temp) do
    {:ok, output, state} = PidController.output(temp, value())
    Agent.update(__MODULE__, fn _ -> state end)
    output
  end
end

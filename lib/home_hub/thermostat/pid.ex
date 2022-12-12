defmodule HomeHub.Thermostat.PID do
  use Agent

  def start_link(settings),
    do: Agent.start_link(fn -> PidController.new(settings) end, name: __MODULE__)

  def value, do: Agent.get(__MODULE__, & &1)

  def update_set_point(new_point),
    do: Agent.update(__MODULE__, &PidController.set_setpoint(&1, new_point))

  def output(temp) do
    {:ok, output, state} = PidController.output(temp, value())
    Agent.update(__MODULE__, fn _ -> state end)
    output
  end
end

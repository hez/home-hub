defmodule HomeHub.Thermostat.PID do
  @callback start_link(list()) :: {:ok, pid} | {:error, {:already_started, pid} | term}
  @callback value() :: float()
  @callback update_set_point(float()) :: any()
  @callback output(float()) :: float()

  @pid_impl HomeHub.Thermostat.PID.PIDController
  def impl, do: @pid_impl
end

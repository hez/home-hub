defmodule HomeHub.Thermostat.DummyFanIO do
  use Agent

  @behaviour HomeHub.IO
  @name __MODULE__
  use HomeHub.IO

  def start_link(opts), do: Agent.start_link(fn -> opts end, name: @name)

  def on, do: Logger.debug("#{@name} turning ON")

  def off, do: Logger.debug("#{@name} turning OFF")

  def state, do: false
end

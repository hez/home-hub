defmodule HomeHub.Thermostat.DummyHeaterIO do
  use Agent

  @behaviour HomeHub.IO
  @name __MODULE__
  use HomeHub.IO

  def start_link(_opts), do: Agent.start_link(fn -> %{} end, name: @name)
end

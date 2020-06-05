defmodule HomeHub.IO.DummyLight do
  @behaviour HomeHub.IO.Light

  require Logger

  alias HomeHub.IO.Light

  @impl Light
  @spec on(Light.t(), integer()) :: Light.t()
  def on(light, _level), do: light

  @impl Light
  @spec off(Light.t()) :: Light.t()
  def off(light), do: light
end

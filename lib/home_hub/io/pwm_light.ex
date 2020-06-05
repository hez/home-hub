defmodule HomeHub.IO.PWMLight do
  @behaviour HomeHub.IO.Light

  require Logger

  alias HomeHub.IO.Light

  # Current power modules do 100-300hz
  @frequency 280
  @hardware_pwm_max 1_000_000

  @type pwm_response() :: :ok | {:error, atom()}

  @impl Light
  @spec on(Light.t(), integer()) :: Light.t()
  def on(%_{gpio_pin: pin} = light, level) do
    case Pigpiox.Pwm.hardware_pwm(pin, @frequency, percent_to_level(light, level)) do
      :ok -> light
      msg -> Logger.warn("Got error setting light level #{inspect(msg)}")
    end
  end

  @impl Light
  @spec off(Light.t()) :: Light.t()
  def off(light), do: on(light, 0)

  def percent_to_level(%_{inverted: true}, level),
    do: round(abs(level - 100) / 100.0 * @hardware_pwm_max)

  def percent_to_level(_, _), do: raise("Unsupported light")
end

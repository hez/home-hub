defmodule HomeHub.IO.Light do
  alias __MODULE__

  defstruct type: nil,
            name: :light,
            title: "Light",
            gpio_pin: nil,
            inverted: true,
            level: 0,
            last_level: 0,
            on: false

  @type t() :: %Light{
          type: module(),
          name: atom(),
          title: String.t(),
          gpio_pin: integer(),
          inverted: boolean(),
          level: integer(),
          last_level: integer(),
          on: boolean()
        }

  @callback on(t(), integer()) :: t()
  @callback off(t()) :: t()

  @default_on_level 50

  @spec on(t(), integer() | nil) :: t()
  def on(%_{last_level: 0} = light, nil), do: on(light, @default_on_level)
  def on(%_{last_level: level} = light, nil), do: on(light, level)

  def on(%_{type: type, level: old_level} = light, level) when is_integer(level) do
    light = type.on(light, level)
    %{light | last_level: old_level, level: level, on: true}
  end

  @spec off(t()) :: t()
  def off(%_{type: type, level: old_level} = light) do
    light = type.off(light)
    %{light | last_level: old_level, level: 0, on: false}
  end
end

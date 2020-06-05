defmodule HomeHub.Lights do
  use Agent

  alias HomeHub.IO.Light

  @name __MODULE__

  def start_link(opts) do
    lights =
      opts
      |> Keyword.get(:lights)
      |> Enum.map(&{&1.name, &1})
      |> Enum.into(%{})

    Agent.start_link(fn -> lights end, name: @name)
  end

  @spec get(atom()) :: Light.t() | nil
  def get(name), do: Agent.get(@name, &Map.get(&1, name))

  @spec all() :: map()
  def all, do: Agent.get(@name, & &1)

  @spec update(Light.t()) :: :ok
  def update(light), do: Agent.update(@name, fn lights -> %{lights | light.name => light} end)

  @spec toggle(atom() | Light.t()) :: :ok
  def toggle(name) when is_atom(name), do: name |> get() |> toggle()
  def toggle(%_{on: false} = light), do: on(light)
  def toggle(%_{on: true} = light), do: off(light)

  @spec on(atom() | Light.t(), integer() | nil) :: :ok
  def on(light, level \\ nil)
  def on(name, level) when is_atom(name), do: name |> get() |> on(level)
  def on(%_{} = light, level), do: light |> Light.on(level) |> update()

  @spec off(atom() | Light.t()) :: :ok
  def off(name) when is_atom(name), do: name |> get() |> off()
  def off(%_{} = light), do: light |> Light.off() |> update()
end

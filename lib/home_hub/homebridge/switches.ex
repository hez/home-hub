defmodule HomeHub.Homebridge.Switches do
  @moduledoc false
  use Agent

  alias HomebridgeWebhook.StatelessSwitch

  defstruct name: "Button",
            event: :single_press,
            client: nil

  @type t() :: %__MODULE__{
          name: String.t(),
          event: StatelessSwitch.event(),
          client: HomebridgeWebhook.client()
        }

  @name __MODULE__

  def start_link(opts) do
    switches =
      opts
      |> Keyword.get(:switches)
      |> Enum.map(&to_stateless_switch/1)
      |> Enum.into(%{})

    Agent.start_link(fn -> switches end, name: @name)
  end

  @spec get(String.t()) :: t()
  def get(name), do: Agent.get(@name, &Map.get(&1, name))

  @spec all() :: map()
  def all, do: @name |> Agent.get(& &1) |> Map.values()

  @spec press(String.t()) :: HomebridgeWebhook.result()
  def press(name) do
    switch = get(name)
    StatelessSwitch.press(switch.client, switch.event)
  end

  defp to_stateless_switch(%{
         name: name,
         event: event,
         accessory_id: accessory_id,
         button_name: button_name
       }) do
    {name,
     %__MODULE__{name: name, event: event, client: StatelessSwitch.new(accessory_id, button_name)}}
  end
end

defmodule HomeHubWeb.HAPButtonsComponent do
  @moduledoc false
  use HomeHubWeb, :live_component
  alias HomeHub.HAP.StatelessSwitch

  @impl true
  def handle_event("press", params, socket) do
    name = String.to_existing_atom(params["name"])
    event = String.to_integer(params["event"])
    StatelessSwitch.press(name, event)
    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex py-6 justify-center">
      <div class="grid grid-cols-3 gap-6">
        <.hap_button name="hap_switch_1" event="0" phx-click="press" phx-target={@myself}>
          <.exit_icon class="h-7 w-7 mr-3" fill="fill-orange-800" /> Leaving
        </.hap_button>
        <.hap_button name="hap_switch_1" event="1" phx-click="press" phx-target={@myself}>
          <Heroicons.moon outline class="h-7 w-7 mr-3" /> Bed Time
        </.hap_button>
        <.hap_button name="hap_switch_1" event="2" phx-click="press" phx-target={@myself}>
          <.sunrise_icon class="h-7 w-7 mr-3" fill="fill-yellow-300" /> Morning
        </.hap_button>

        <.hap_button name="hap_switch_2" event="0" phx-click="press" phx-target={@myself}>
          <.lamp_icon class="h-7 w-7 mr-3" fill="fill-yellow-500" /> Lamps
        </.hap_button>
      </div>
    </div>
    """
  end

  attr :name, :string, required: true
  attr :event, :string, required: true
  attr :rest, :global, include: ~w(disabled form name value)
  slot :inner_block, required: true

  def hap_button(assigns) do
    ~H"""
    <button
      type="button"
      aria-label=""
      class="inline-block px-10 py-6 bg-blue-600 text-white text-2xl leading-tight rounded shadow-md hover:bg-blue-700 hover:shadow-lg focus:bg-blue-700 focus:shadow-lg focus:outline-none focus:ring-0 active:bg-blue-800 active:shadow-lg transition duration-150 ease-in-out"
      phx-value-name={@name}
      phx-value-event={@event}
      {@rest}
    >
      <div class="flex">
        <%= render_slot(@inner_block) %>
      </div>
    </button>
    """
  end
end

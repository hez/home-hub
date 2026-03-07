defmodule HomeHubWeb.ScenesLive do
  @moduledoc false
  use HomeHubWeb, :live_view
  require Logger
  import HomeHubWeb.HomexComponents

  alias HomeHub.HomexDevice

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.dashboard flash={@flash} nav={@nav} sensors={@sensors}>
      <div class="pt-10 flex py-6 justify-center">
        <div class="grid grid-cols-3 gap-6">
          <.homex_button name="scene_button_press" event="1">
            <.hap_icon_sunrise class="fill-yellow-300" /> Morning
          </.homex_button>
          <.homex_button name="scene_button_press" event="2">
            <.icon name="hero-cube" class="h-10 w-10 mr-3" /> "All"
          </.homex_button>
          <.homex_button name="scene_button_press" event="3">
            <.hap_icon_exit class="fill-black-500" /> Leaving
          </.homex_button>

          <.homex_button name="scene_button_press" event="4">
            <.hap_icon_lamp class="fill-yellow-500" /> Lamps
          </.homex_button>
          <.homex_button name="scene_button_press" event="4">
            <.icon name="hero-light-bulb" class="h-10 w-10 mr-3 text-orange-700" /> Entry
          </.homex_button>
          <.homex_button name="scene_button_press" event="6">
            <.icon name="hero-film" class="h-10 w-10 mr-3 text-yellow-300" /> Movie
          </.homex_button>
        </div>
      </div>
    </Layouts.dashboard>
    """
  end

  @impl true
  def handle_event("homex_button_press", %{"event" => event}, socket) do
    case event do
      "1" -> HomexDevice.Button1.trigger()
      "2" -> HomexDevice.Button2.trigger()
      "3" -> HomexDevice.Button3.trigger()
      "4" -> HomexDevice.Button4.trigger()
      "5" -> HomexDevice.Button5.trigger()
      "6" -> HomexDevice.Button6.trigger()
    end

    {:noreply, socket}
  end

  def handle_event(_event, _params, socket), do: {:noreply, socket}

  @impl true
  def handle_info(_, socket), do: {:noreply, socket}
end

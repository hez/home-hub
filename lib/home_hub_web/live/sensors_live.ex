defmodule HomeHubWeb.SensorsLive do
  @moduledoc false
  use HomeHubWeb, :live_view
  require Logger
  import HomeHubWeb.HomexComponents

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.dashboard flash={@flash} nav={@nav} sensors={@sensors}>
      <div class="flex flex-wrap gap-4">
        <%= for {name, sensor} <- @sensors do %>
          <.sensor_widget sensor={Map.put(sensor, :name, name)} />
        <% end %>
      </div>
    </Layouts.dashboard>
    """
  end

  @impl true
  def handle_info(_, socket), do: {:noreply, socket}

  @impl true
  def handle_event(_event, _params, socket), do: {:noreply, socket}
end

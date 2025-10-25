defmodule HomeHubWeb.SettingsLive do
  @moduledoc false
  use HomeHubWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.dashboard flash={@flash} nav={@nav} sensors={@sensors}>
      <Layouts.theme_toggle />
    </Layouts.dashboard>
    """
  end
end

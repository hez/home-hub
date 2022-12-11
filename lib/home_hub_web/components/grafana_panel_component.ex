defmodule HomeHubWeb.GrafanaPanelComponent do
  @moduledoc false
  use HomeHubWeb, :live_component

  attr :src, :string, required: true
  attr :width, :string, default: "450", required: false
  attr :height, :string, default: "200", required: false

  def render(assigns) do
    ~H"""
    <iframe src={@src} width={@width} height={@height} frameborder="0"></iframe>
    """
  end
end

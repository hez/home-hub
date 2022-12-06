defmodule HomeHubWeb.AppComponents do
  @moduledoc false
  use Phoenix.Component
  # This is required for use of `~p""` and since we import this in HomeHubWeb
  # for global availablility we can't do the regular `use HomeHubWeb, :live_component`
  #  use Phoenix.VerifiedRoutes,
  #    endpoint: HomeHubWeb.Endpoint,
  #    router: HomeHubWeb.Router,
  #    statics: HomeHubWeb.static_paths()

  @default_icon_classes "h-12 w-12"

  attr :phx_click, :string, default: "", required: false
  attr :phx_target, :string, default: nil, required: false
  attr :on, :boolean, default: false, required: false
  slot :inner_block, required: true

  def toggle(assigns) do
    ~H"""
    <div class="px-4 py-2" phx-click={@phx_click} phx-target={@phx_target}>
      <%= if @on do %>
        <.on_toggle_icon fill="fill-orange-500" />
      <% else %>
        <.off_toggle_icon fill="fill-blue-500" />
      <% end %>
    </div>

    <div class="px-4 py-2 text-4xl" phx-click={@phx_click} phx-target={@phx_target}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  attr :class, :string, default: @default_icon_classes, required: false
  attr :fill, :string, default: "gray-500", required: false

  def on_toggle_icon(assigns) do
    ~H"""
    <svg
      class={"bi bi-toggle-on #{@class} #{@fill}"}
      width="1em"
      height="1em"
      viewBox="0 0 16 16"
      fill="currentColor"
      xmlns="http://www.w3.org/2000/svg"
    >
      <path
        fill-rule="evenodd"
        d="M5 3a5 5 0 0 0 0 10h6a5 5 0 0 0 0-10H5zm6 9a4 4 0 1 0 0-8 4 4 0 0 0 0 8z"
      />
    </svg>
    """
  end

  attr :class, :string, default: @default_icon_classes, required: false
  attr :fill, :string, default: "gray-500", required: false

  def off_toggle_icon(assigns) do
    ~H"""
    <svg
      class={"bi bi-toggle-off #{@class} #{@fill}"}
      width="1em"
      height="1em"
      viewBox="0 0 16 16"
      fill="currentColor"
      xmlns="http://www.w3.org/2000/svg"
    >
      <path
        fill-rule="evenodd"
        d="M11 4a4 4 0 0 1 0 8H8a4.992 4.992 0 0 0 2-4 4.992 4.992 0 0 0-2-4h3zm-6 8a4 4 0 1 1 0-8 4 4 0 0 1 0 8zM0 8a5 5 0 0 0 5 5h6a5 5 0 0 0 0-10H5a5 5 0 0 0-5 5z"
      />
    </svg>
    """
  end

  attr :class, :string, default: @default_icon_classes, required: false
  attr :fill, :string, default: "gray-500", required: false

  def fan_icon(assigns) do
    ~H"""
    <svg
      class={"#{@class} #{@fill}"}
      version="1.1"
      id="Capa_1"
      xmlns="http://www.w3.org/2000/svg"
      xmlns:xlink="http://www.w3.org/1999/xlink"
      x="0px"
      y="0px"
      viewBox="0 0 298.666 298.666"
      style="enable-background:new 0 0 298.666 298.666;"
      xml:space="preserve"
    >
      <g>
        <path d="M162.466,137.052c7.732-7.119,39.268-38.192,36.846-69.387c-2.057-26.462-32.63-34.426-49.585-34.426
          c-16.956,0-47.464,7.964-49.52,34.426c-2.373,30.564,27.901,61.014,36.41,68.928c3.257-3.25,7.751-5.26,12.716-5.26
          C154.52,131.333,159.182,133.54,162.466,137.052z" />
        <path d="M131.332,149.333c0-3.023,0.754-5.867,2.07-8.369c-11.169-3.415-52.577-14.314-77.824,3
          c-21.89,15.012-13.499,45.469-5.021,60.154c8.479,14.684,30.628,37.122,54.573,25.672c25.487-12.189,37.025-48.342,40.714-62.802
          C137.573,165.362,131.332,158.08,131.332,149.333z" />
        <path d="M243.072,144.464c-25.053-17.181-66.036-6.541-77.584-3.028c1.169,2.387,1.844,5.061,1.844,7.897
          c0,8.808-6.33,16.125-14.686,17.682c3.546,14.076,15.072,50.938,40.874,63.275c23.944,11.452,46.128-11.043,54.606-25.729
          C256.604,189.878,264.961,159.477,243.072,144.464z" />
        <path d="M149.333,0C66.99,0,0,66.99,0,149.333s66.99,149.333,149.333,149.333s149.333-66.99,149.333-149.333S231.676,0,149.333,0z
           M149.333,282.666C75.812,282.666,16,222.854,16,149.333S75.812,16,149.333,16s133.333,59.813,133.333,133.333
          S222.853,282.666,149.333,282.666z" />
      </g>
    </svg>
    """
  end

  attr :class, :string, default: @default_icon_classes, required: false
  attr :fill, :string, default: "gray-500", required: false

  def fire_icon(assigns) do
    ~H"""
    <svg
      class={"#{@class} #{@fill}"}
      version="1.1"
      id="Capa_1"
      xmlns="http://www.w3.org/2000/svg"
      xmlns:xlink="http://www.w3.org/1999/xlink"
      x="0px"
      y="0px"
      viewBox="0 0 192 192"
      style="enable-background:new 0 0 192 192;"
      xml:space="preserve"
    >
      <path d="M165.563,69.663c-2.031-2.032-5.043-2.723-7.758-1.784c-2.714,0.94-4.653,3.348-4.992,6.201
        c-0.005,0.042-0.665,4.356-3.325,6.998c-0.527,0.523-1.115,0.992-1.733,1.41c-1.781-10.63-5.977-27.957-15.556-42.325
        c-15.201-22.802-44.925-29.846-46.183-30.134c-3.433-0.789-7.097,0.8-8.603,3.983c-1.494,3.157-0.754,6.806,1.976,8.968
        c0.519,0.531,3.678,4.061,3.401,10.982c-0.219,5.479-2.434,7.757-10.08,14.81c-2.312,2.133-4.933,4.55-7.853,7.47
        c-4.757,4.756-8.467,9.828-11.287,14.433c-0.14-0.228-0.282-0.454-0.427-0.678c-5.278-8.21-20.207-13.514-23.146-14.494
        c-3.343-1.115-7.356-0.115-9.16,2.916c-1.758,2.956-1.602,6.369,0.797,8.769c0.493,1.026,2.303,5.577,1.705,16.042
        c-0.297,5.195-4.604,11.472-9.163,18.118C7.531,111.03,0,122.006,0,135.796c0,24.329,23.715,43.876,24.724,44.697
        c1.337,1.086,3.007,1.679,4.729,1.679H64.67c2.75,0,5.28-1.505,6.592-3.923c1.312-2.417,1.195-5.358-0.303-7.665
        c-3.029-4.661-11.106-18.975-12.086-29.108c-0.26-2.68-0.187-5.492,0.085-8.249c5.352,6.953,11.53,10.203,12.421,10.648
        c2.356,1.179,5.158,1.033,7.38-0.38c2.223-1.415,3.541-3.892,3.471-6.525c-0.118-4.468,0.242-18.056,3.276-27.16
        c1.128-3.385,3.58-6.872,6.331-9.983c0.452,2.115,1.029,4.433,1.762,6.959c2.687,9.253,11.509,15,20.042,20.557
        c8.105,5.279,16.487,10.738,18.873,18.446c4.178,13.497-8.389,22.301-8.887,22.643c-2.75,1.833-3.976,5.25-3.018,8.414
        c0.958,3.163,3.873,5.327,7.178,5.327h37.504c1.603,0,3.164-0.514,4.454-1.466c0.909-0.67,22.255-16.818,22.255-50.855
        C192,96.484,166.643,70.743,165.563,69.663z" />
    </svg>
    """
  end

  attr :class, :string, default: @default_icon_classes, required: false
  attr :fill, :string, default: "gray-500", required: false

  def caret_down_filled_icon(assigns) do
    ~H"""
    <svg
      class={"bi bi-caret-down-square-fill #{@class} #{@fill}"}
      width="1em"
      height="1em"
      viewBox="0 0 16 16"
      fill="currentColor"
      xmlns="http://www.w3.org/2000/svg"
    >
      <path
        fill-rule="evenodd"
        d="M0 2a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V2zm4 4a.5.5 0 0 0-.374.832l4 4.5a.5.5 0 0 0 .748 0l4-4.5A.5.5 0 0 0 12 6H4z"
      />
    </svg>
    """
  end

  attr :class, :string, default: @default_icon_classes, required: false
  attr :fill, :string, default: "gray-500", required: false

  def caret_up_filled_icon(assigns) do
    ~H"""
    <svg
      class={"bi bi-caret-up-square-fill #{@class} #{@fill}"}
      width="1em"
      height="1em"
      viewBox="0 0 16 16"
      fill="currentColor"
      xmlns="http://www.w3.org/2000/svg"
    >
      <path
        fill-rule="evenodd"
        d="M0 2a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V2zm4 9a.5.5 0 0 1-.374-.832l4-4.5a.5.5 0 0 1 .748 0l4 4.5A.5.5 0 0 1 12 11H4z"
      />
    </svg>
    """
  end
end

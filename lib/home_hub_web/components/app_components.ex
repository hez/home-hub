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

  attr :class, :string, default: @default_icon_classes, required: false
  attr :fill, :string, default: "gray-500", required: false

  def lamp_icon(assigns) do
    ~H"""
    <svg
      class={"bi bi-caret-up-square-fill #{@class} #{@fill}"}
      version="1.1"
      xmlns="http://www.w3.org/2000/svg"
      viewBox="0 0 451.541 451.541"
      xmlns:xlink="http://www.w3.org/1999/xlink"
      enable-background="new 0 0 451.541 451.541"
    >
      <g>
        <path d="m387.879,194.837l-70.247-189.939c-1.089-2.943-3.896-4.898-7.035-4.898h-169.653c-3.139,0-5.946,1.955-7.034,4.898l-70.248,189.939c-0.852,2.301-0.523,4.874 0.879,6.888 1.402,2.014 3.701,3.214 6.155,3.214h121.181l10.136,176.105h-37.381c-4.142,0-7.5,3.358-7.5,7.5v20.249h-10.388c-4.142,0-7.5,3.358-7.5,7.5v27.749c0,4.142 3.358,7.5 7.5,7.5h158.054c4.142,0 7.5-3.358 7.5-7.5v-27.749c0-4.142-3.358-7.5-7.5-7.5h-10.388v-20.249c0-4.142-3.358-7.5-7.5-7.5h-37.381l10.136-176.105h11.104v81.015c0,4.142 3.358,7.5 7.5,7.5s7.5-3.358 7.5-7.5v-81.015h95.077c2.454,0 4.752-1.2 6.155-3.214 1.401-2.015 1.73-4.587 0.878-6.888zm-26.438-28.242h-271.341l47.924-129.578h175.494l47.923,129.578zm-56.066-151.595l2.595,7.017h-164.399l2.595-7.017h159.209zm-8.077,421.541h-143.055v-12.749h143.054v12.749zm-17.887-27.749h-107.279v-12.749h107.279v12.749zm-44.906-27.748h-17.466l-10.136-176.105h37.738l-10.136,176.105zm-153.037-191.106l3.086-8.344h282.436l3.086,8.344h-288.608z" />
        <path d="m330.164,146.888l3.651,9.872c1.119,3.027 3.986,4.9 7.035,4.9 0.864,0 1.743-0.15 2.601-0.468 3.885-1.437 5.87-5.75 4.433-9.636l-3.651-9.872c-1.436-3.885-5.75-5.87-9.636-4.433-3.885,1.437-5.87,5.751-4.433,9.637z" />
        <path d="m296.787,56.642l25.95,70.166c1.12,3.027 3.986,4.9 7.035,4.9 0.864,0 1.743-0.15 2.601-0.468 3.885-1.437 5.87-5.751 4.433-9.636l-25.95-70.166c-1.437-3.885-5.752-5.871-9.636-4.433-3.885,1.438-5.87,5.752-4.433,9.637z" />
      </g>
    </svg>
    """
  end

  attr :class, :string, default: @default_icon_classes, required: false
  attr :fill, :string, default: "gray-500", required: false

  def exit_icon(assigns) do
    ~H"""
    <svg
      class={"bi bi-caret-up-square-fill #{@class} #{@fill}"}
      version="1.1"
      id="Capa_1"
      xmlns="http://www.w3.org/2000/svg"
      xmlns:xlink="http://www.w3.org/1999/xlink"
      viewBox="0 0 55 55"
      enable-background="new 0 0 55 55;"
    >
      <g>
        <path d="M53.924,24.382c0.101-0.244,0.101-0.519,0-0.764c-0.051-0.123-0.125-0.234-0.217-0.327L41.708,11.293
    c-0.391-0.391-1.023-0.391-1.414,0s-0.391,1.023,0,1.414L50.587,23H29.001c-0.553,0-1,0.447-1,1s0.447,1,1,1h21.586L40.294,35.293
    c-0.391,0.391-0.391,1.023,0,1.414C40.489,36.902,40.745,37,41.001,37s0.512-0.098,0.707-0.293l11.999-11.999
    C53.799,24.616,53.873,24.505,53.924,24.382z" />
        <path d="M36.001,29c-0.553,0-1,0.447-1,1v16h-10V8c0-0.436-0.282-0.821-0.697-0.953L8.442,2h26.559v16c0,0.553,0.447,1,1,1
    s1-0.447,1-1V1c0-0.553-0.447-1-1-1h-34c-0.032,0-0.06,0.015-0.091,0.018C1.854,0.023,1.805,0.036,1.752,0.05
    C1.658,0.075,1.574,0.109,1.493,0.158C1.467,0.174,1.436,0.174,1.411,0.192C1.38,0.215,1.356,0.244,1.328,0.269
    c-0.017,0.016-0.035,0.03-0.051,0.047C1.201,0.398,1.139,0.489,1.093,0.589c-0.009,0.02-0.014,0.04-0.022,0.06
    C1.029,0.761,1.001,0.878,1.001,1v46c0,0.125,0.029,0.243,0.072,0.355c0.014,0.037,0.035,0.068,0.053,0.103
    c0.037,0.071,0.079,0.136,0.132,0.196c0.029,0.032,0.058,0.061,0.09,0.09c0.058,0.051,0.123,0.093,0.193,0.13
    c0.037,0.02,0.071,0.041,0.111,0.056c0.017,0.006,0.03,0.018,0.047,0.024l22,7C23.797,54.984,23.899,55,24.001,55
    c0.21,0,0.417-0.066,0.59-0.192c0.258-0.188,0.41-0.488,0.41-0.808v-6h11c0.553,0,1-0.447,1-1V30
    C37.001,29.447,36.553,29,36.001,29z M23.001,52.633l-20-6.364V2.367l20,6.364V52.633z" />
      </g>
    </svg>
    """
  end

  attr :class, :string, default: @default_icon_classes, required: false
  attr :fill, :string, default: "gray-500", required: false

  def sunrise_icon(assigns) do
    ~H"""
    <svg
      class={"bi bi-caret-up-square-fill #{@class} #{@fill}"}
      viewBox="0 0 16 16"
      xmlns="http://www.w3.org/2000/svg"
      fill="currentColor"
    >
      <path d="M7.646 1.146a.5.5 0 0 1 .708 0l1.5 1.5a.5.5 0 0 1-.708.708L8.5 2.707V4.5a.5.5 0 0 1-1 0V2.707l-.646.647a.5.5 0 1 1-.708-.708l1.5-1.5zM2.343 4.343a.5.5 0 0 1 .707 0l1.414 1.414a.5.5 0 0 1-.707.707L2.343 5.05a.5.5 0 0 1 0-.707zm11.314 0a.5.5 0 0 1 0 .707l-1.414 1.414a.5.5 0 1 1-.707-.707l1.414-1.414a.5.5 0 0 1 .707 0zM8 7a3 3 0 0 1 2.599 4.5H5.4A3 3 0 0 1 8 7zm3.71 4.5a4 4 0 1 0-7.418 0H.499a.5.5 0 0 0 0 1h15a.5.5 0 0 0 0-1h-3.79zM0 10a.5.5 0 0 1 .5-.5h2a.5.5 0 0 1 0 1h-2A.5.5 0 0 1 0 10zm13 0a.5.5 0 0 1 .5-.5h2a.5.5 0 0 1 0 1h-2a.5.5 0 0 1-.5-.5z" />
    </svg>
    """
  end
end

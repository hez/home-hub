defmodule HomeHubWeb.LiveHelpers do
  @moduledoc false
  import Phoenix.LiveView
  import Phoenix.LiveView.Helpers

  alias HomeHubWeb.Router.Helpers, as: Routes
  # alias Phoenix.LiveView.JS

  def nav_menu(assigns) do
    ~H"""
    <header>
      <section class="container">
        <nav role="navigation">
          <ul class="flex">
            <li class="flex-1 mr-2">
              <%= live_redirect "Home", to: Routes.dashboard_path(HomeHubWeb.Endpoint, :index), class: "text-center block rounded text-3xl py-2 px-4 bg-gray-800 border-gray-800 text-blue-300 hover:border-gray-200 hover:bg-gray-200" %>
            </li>
            <li class="flex-1 mr-2">
              <%= live_redirect "Current", to: Routes.current_path(HomeHubWeb.Endpoint, :index), class: "text-center block rounded text-3xl py-2 px-4 bg-gray-800 border-gray-800 text-blue-300 hover:border-gray-200 hover:bg-gray-200" %>
            </li>
            <li class="flex-1 mr-2">
              <a
                class="text-center block rounded text-3xl py-2 px-4 bg-gray-800 border-gray-800 text-blue-300 hover:border-gray-200 hover:bg-gray-200"
                href="/history"
              >
                History
              </a>
            </li>
          </ul>
        </nav>
      </section>
      <section class="container">
        <%= if @status do %>
          <div class="flex flex-row-reverse m-4">
            <div class="text-4xl">
              Current: <b><%= Float.round(@status.temperature, 1) %>&#176;C</b>
              at <b><%= @status.humidity |> Float.round(0) |> trunc() %>%</b>
            </div>
          </div>
        <% end %>
      </section>
    </header>
    """
  end

  def button(assigns) do
    assigns =
      assigns
      |> assign_new(:phx_click, fn -> "" end)
      |> assign_new(:phx_target, fn -> nil end)
      |> assign_new(:label, fn -> "Button" end)
      |> assign_new(:value, fn -> assigns.label end)
      |> assign_new(:inner_block, fn -> nil end)

    ~H"""
    <button
      class="rounded-full bg-sky-800 font-bold text-2xl border-sky-800 py-2 px-8 m-4"
      phx-click={@phx_click}
      phx-target={@phx_target}
      value={@value}>
      <%= if is_nil(@inner_block) do %>
        <%= @label %>
      <% else %>
        <%= render_slot(@inner_block) %>
      <% end %>
    </button>
    """
  end

  def toggle(assigns) do
    assigns =
      assigns
      |> assign_new(:phx_click, fn -> "" end)
      |> assign_new(:phx_target, fn -> nil end)

    ~H"""
    <div class="px-4 py-2" phx-click={@phx_click} phx-target={@phx_target}>
      <%= if @on do %>
        <img class="icon icon-on-orange" src={Routes.static_path(HomeHubWeb.Endpoint, "/images/icons/toggle-on.svg")}>
      <% else %>
        <img class="icon icon-action" src={Routes.static_path(HomeHubWeb.Endpoint, "/images/icons/toggle-off.svg")}>
      <% end %>
    </div>

    <div class="px-4 py-2 text-4xl" phx-click={@phx_click} phx-target={@phx_target}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  def icon(assigns) do
    assigns =
      assigns
      |> assign_new(:on, fn -> false end)
      |> assign_new(:on_colour, fn -> "" end)
      |> assign_new(:off_colour, fn -> "icon-on-gray" end)
      |> assign_new(:phx_click, fn -> nil end)
      |> assign_new(:phx_target, fn -> nil end)

    ~H"""
    <div
      class="px-4 py-2"
      phx-click={@phx_click}
      phx-target={@phx_target}>
      <img class={"icon #{if assigns.on, do: assigns.on_colour, else: assigns.off_colour}"} src={@src} />
    </div>
    """
  end
end

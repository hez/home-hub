defmodule HomeHubWeb.Layouts do
  use HomeHubWeb, :html
  import ExThermostatWeb.LiveComponent, only: [temperature_display: 1]

  embed_templates "layouts/*"

  attr :active_tab, :atom

  def navigation_tabs(assigns) do
    ~H"""
    <section class="container">
      <nav role="navigation">
        <ul class="flex">
          <li class="flex-1 mr-2">
            <.nav_link to={~p"/"} active={@active_tab == :dashboard}>Home</.nav_link>
          </li>
          <li class="flex-1 mr-2">
            <.nav_link to={~p"/"} active={@active_tab == :history}>History</.nav_link>
          </li>
        </ul>
      </nav>
    </section>
    """
  end

  slot :inner_block, required: true
  attr :to, :string, required: true
  attr :active, :boolean, default: false, required: false

  def nav_link(assigns) do
    ~H"""
    <.link
      navigate={@to}
      class={"text-center block rounded text-3xl py-2 px-4 text-blue-300 #{if @active, do: "bg-black-100", else: "bg-gray-800 border-gray-800 hover:border-gray-200 hover:bg-gray-200"}"}
      aria-current={if @active, do: "true", else: "false"}
    >
      {render_slot(@inner_block)}
    </.link>
    """
  end
end

defmodule HomeHubWeb.LiveHelpers do
  import Phoenix.LiveView
  import Phoenix.LiveView.Helpers

  alias LiveBeatsWeb.Router.Helpers, as: Routes
  alias Phoenix.LiveView.JS

  def nav_menu(assigns) do
    ~H"""
    <header>
      <section class="container">
        <nav role="navigation">
          <ul class="flex">
            <li class="flex-1 mr-2">
              <a
                class="text-center block rounded text-3xl py-2 px-4 bg-gray-800 border-gray-800 text-blue-300 hover:border-gray-200 hover:bg-gray-200"
                href="/"
              >
                Home
              </a>
            </li>
            <li class="flex-1 mr-2">
              <a
                class="text-center block rounded text-3xl py-2 px-4 bg-gray-800 border-gray-800 text-blue-300 hover:border-gray-200 hover:bg-gray-200"
                href="/current"
              >
                Current
              </a>
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
          <div class="flex flex-row-reverse">
            <div class="text-2xl">
              Current: <b><%= Float.round(@status.temperature, 1) %>&#176;C</b>
              at <b><%= @status.humidity |> Float.round(0) |> trunc() %>%</b>
            </div>
          </div>
        <% end %>
      </section>
    </header>
    """
  end
end

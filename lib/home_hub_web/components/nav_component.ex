defmodule HomeHubWeb.NavComponent do
  @moduledoc false
  use HomeHubWeb, :live_component

  attr :status, :map, required: false

  def render(assigns) do
    ~H"""
    <div>
      <section class="container">
        <nav role="navigation">
          <ul class="flex">
            <li class="flex-1 mr-2">
              <%= live_redirect("Home",
                to: ~p"/",
                class:
                  "text-center block rounded text-3xl py-2 px-4 bg-gray-800 border-gray-800 text-blue-300 hover:border-gray-200 hover:bg-gray-200"
              ) %>
            </li>
            <li class="flex-1 mr-2">
              <%= live_redirect("Current",
                to: ~p"/",
                class:
                  "text-center block rounded text-3xl py-2 px-4 bg-gray-800 border-gray-800 text-blue-300 hover:border-gray-200 hover:bg-gray-200"
              ) %>
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
    </div>
    """
  end
end

defmodule HomeHubWeb.Layouts do
  @moduledoc """
  This module holds layouts and related functionality
  used by your application.
  """
  use HomeHubWeb, :html

  # Embed all files in layouts/* within this module.
  # The default root.html.heex file contains the HTML
  # skeleton of your application, namely HTML headers
  # and other static content.
  embed_templates "layouts/*"

  @doc """
  Renders your app layout.

  This function is typically invoked from every template,
  and it often contains your application menu, sidebar,
  or similar.

  ## Examples

      <Layouts.app flash={@flash}>
        <h1>Content</h1>
      </Layouts.app>

  """
  attr :flash, :map, required: true, doc: "the map of flash messages"

  attr :current_scope, :map,
    default: nil,
    doc: "the current [scope](https://hexdocs.pm/phoenix/scopes.html)"

  slot :inner_block, required: true

  def app(assigns) do
    ~H"""
    <header class="navbar px-4 sm:px-6 lg:px-8">
      <div class="flex-1">
        <a href="/" class="flex-1 flex w-fit items-center gap-2">
          <img src={~p"/images/logo.svg"} width="36" />
          <span class="text-sm font-semibold">v{Application.spec(:phoenix, :vsn)}</span>
        </a>
      </div>

      <div class="flex-none flex items-center gap-4">
        <button onclick="location.href='/'" aria-label="Home" class="btn btn-ghost btn-square">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            class="h-5 w-5"
            viewBox="0 0 20 20"
            fill="currentColor"
            aria-hidden="true"
          >
            <path d="M10.707 1.707a1 1 0 0 0-1.414 0l-7 7A1 1 0 0 0 2.293 10H3v6a1 1 0 0 0 1 1h4a1 1 0 0 0 1-1v-3h2v3a1 1 0 0 0 1 1h4a1 1 0 0 0 1-1v-6h.707a1 1 0 0 0 .707-1.707l-7-7z" />
          </svg>
        </button>

        <.theme_toggle />
      </div>
    </header>

    <main class="px-4 py-20 sm:px-6 lg:px-8">
      <div class="mx-auto max-w-2xl space-y-4">
        {render_slot(@inner_block)}
      </div>
    </main>

    <.flash_group flash={@flash} />
    """
  end

  attr :flash, :map, required: true, doc: "the map of flash messages"

  attr :current_scope, :map,
    default: nil,
    doc: "the current [scope](https://hexdocs.pm/phoenix/scopes.html)"

  attr :nav, :map, required: true
  attr :sensors, :map

  slot :inner_block, required: true

  def dashboard(assigns) do
    assigns = assigns |> assign(:active_tab, assigns.nav.active_tab)

    ~H"""
    <header class="bg-base-200 px-4 sm:px-6 lg:px-8">
      <nav role="navigation">
        <ul class="flex items-center gap-1 justify-center">
          <li class="flex items-center">
            <.nav_link to={~p"/"} active={@active_tab == :dashboard}>
              <.icon name="hero-home" class="size-7" />
              <span class="pt-4">Home</span>
            </.nav_link>
          </li>
          <li class="flex items-center">
            <.nav_link to={~p"/scenes"} active={@active_tab == :scenes}>
              <.icon name="hero-sparkles" class="size-7" />
              <span class="pt-4">Scenes</span>
            </.nav_link>
          </li>
          <li class="flex items-center">
            <.nav_link to={~p"/sensors"} active={@active_tab == :sensors}>
              <.icon
                :if={HomeHub.Sensors.alertable?(@sensors)}
                name="hero-exclamation-triangle"
                class="size-7 text-error"
              />
              <.icon
                :if={not HomeHub.Sensors.alertable?(@sensors)}
                name="hero-signal"
                class="size-5"
              />
              <span class="pt-4">Sensors</span>
            </.nav_link>
          </li>
        </ul>
      </nav>
    </header>

    <main class="px-4 py-5 sm:px-6 lg:px-8">
      <div class="container mx-auto">
        {render_slot(@inner_block)}
      </div>
    </main>

    <.flash_group flash={@flash} />
    """
  end

  slot :inner_block, required: true
  attr :to, :string, required: true
  attr :active, :boolean, default: false

  def nav_link(assigns) do
    ~H"""
    <.link
      navigate={@to}
      class={[
        "flex content-center items-center gap-2 px-6 text-3xl rounded-t-lg transition-colors duration-150",
        if(@active,
          do: "bg-base-100",
          else: "bg-base-300 text-base-content/50 hover:text-base-content/80 hover:bg-base-200"
        )
      ]}
      aria-current={if @active, do: "page", else: "false"}
    >
      {render_slot(@inner_block)}
    </.link>
    """
  end

  @doc """
  Shows the flash group with standard titles and content.

  ## Examples

      <.flash_group flash={@flash} />
  """
  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :id, :string, default: "flash-group", doc: "the optional id of flash container"

  def flash_group(assigns) do
    ~H"""
    <div id={@id} aria-live="polite">
      <.flash kind={:info} flash={@flash} />
      <.flash kind={:error} flash={@flash} />

      <.flash
        id="client-error"
        kind={:error}
        title={gettext("We can't find the internet")}
        phx-disconnected={show(".phx-client-error #client-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#client-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>

      <.flash
        id="server-error"
        kind={:error}
        title={gettext("Something went wrong!")}
        phx-disconnected={show(".phx-server-error #server-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#server-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>
    </div>
    """
  end

  @doc """
  Provides dark vs light theme toggle based on themes defined in app.css.

  See <head> in root.html.heex which applies the theme before page load.
  """
  def theme_toggle(assigns) do
    ~H"""
    <div class="card relative flex flex-row items-center border-2 border-base-300 bg-base-300 rounded-full">
      <div class="absolute w-1/3 h-full rounded-full border-1 border-base-200 bg-base-100 brightness-200 left-0 [[data-theme=light]_&]:left-1/3 [[data-theme=dark]_&]:left-2/3 transition-[left]" />

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="system"
      >
        <.icon name="hero-computer-desktop-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="light"
      >
        <.icon name="hero-sun-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="dark"
      >
        <.icon name="hero-moon-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>
    </div>
    """
  end
end

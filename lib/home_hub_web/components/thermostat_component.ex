defmodule HomeHubWeb.ThermostatComponent do
  @moduledoc false
  use Phoenix.LiveComponent
  import HomeHubWeb.AppComponents

  @modes ["heat", "cool"]
  @adjustment_amount 0.5

  @impl true
  def handle_event("toggle_mode", %{"mode" => mode}, socket) when mode in @modes do
    Thermostat.dispatch(:thermostat_toggle_mode, String.to_atom(mode))
    {:noreply, socket}
  end

  def handle_event("target_adjust", %{"amount" => amount}, socket) do
    {amount, _} = Float.parse(amount)
    Thermostat.dispatch(:thermostat_target_adjust, amount)
    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    mode = assigns.thermostat.mode
    heat_on = mode == :heat
    cool_on = mode == :cool
    active = heat_on or cool_on

    assigns =
      assigns
      |> assign(:heat_on, heat_on)
      |> assign(:cool_on, cool_on)
      |> assign(:active, active)
      |> assign(:adjustment_amount, @adjustment_amount)
      |> assign(:target_color, target_color(assigns.thermostat))

    ~H"""
    <div class="flex flex-col gap-4">
      <%!-- Mode toggles row --%>
      <div class="grid grid-cols-2 gap-3">
        <%!-- Heat button --%>
        <button
          id="thermostat-heat-btn"
          phx-click="toggle_mode"
          phx-value-mode="heat"
          phx-target={@myself}
          class={[
            "relative flex items-center gap-3 rounded-2xl border-2 px-5 py-4 transition-all duration-200 select-none touch-manipulation",
            if(@heat_on,
              do: "border-orange-400 bg-orange-500/10",
              else: "border-base-300 bg-base-200 active:bg-base-300"
            )
          ]}
        >
          <.fire_icon class={"h-9 w-9 shrink-0 transition-colors duration-200 #{if @heat_on, do: "fill-orange-500", else: "fill-base-content/25"}"} />
          <div class="flex flex-col items-start gap-0.5 min-w-0">
            <span class={[
              "text-xl font-semibold leading-tight transition-colors duration-200",
              if(@heat_on, do: "text-orange-500", else: "text-base-content/50")
            ]}>
              Heat
            </span>
            <span class={[
              "text-xs font-medium transition-colors duration-200",
              if(@heat_on, do: "text-orange-400", else: "text-base-content/30")
            ]}>
              {if @heat_on, do: "On", else: "Off"}
            </span>
          </div>
          <%!-- pill toggle --%>
          <div class={[
            "ml-auto shrink-0 w-11 h-6 rounded-full transition-all duration-200 relative",
            if(@heat_on, do: "bg-orange-500", else: "bg-base-300")
          ]}>
            <div class={[
              "absolute top-0.5 h-5 w-5 rounded-full bg-white shadow-sm transition-all duration-200",
              if(@heat_on, do: "left-[22px]", else: "left-0.5")
            ]} />
          </div>
        </button>

        <%!-- A/C button --%>
        <button
          id="thermostat-cool-btn"
          phx-click="toggle_mode"
          phx-value-mode="cool"
          phx-target={@myself}
          class={[
            "relative flex items-center gap-3 rounded-2xl border-2 px-5 py-4 transition-all duration-200 select-none touch-manipulation",
            if(@cool_on,
              do: "border-sky-400 bg-sky-500/10",
              else: "border-base-300 bg-base-200 active:bg-base-300"
            )
          ]}
        >
          <.fan_icon class={"h-9 w-9 shrink-0 transition-colors duration-200 #{if @cool_on, do: "fill-sky-500", else: "fill-base-content/25"}"} />
          <div class="flex flex-col items-start gap-0.5 min-w-0">
            <span class={[
              "text-xl font-semibold leading-tight transition-colors duration-200",
              if(@cool_on, do: "text-sky-500", else: "text-base-content/50")
            ]}>
              A/C
            </span>
            <span class={[
              "text-xs font-medium transition-colors duration-200",
              if(@cool_on, do: "text-sky-400", else: "text-base-content/30")
            ]}>
              {if @cool_on, do: "On", else: "Off"}
            </span>
          </div>
          <%!-- pill toggle --%>
          <div class={[
            "ml-auto shrink-0 w-11 h-6 rounded-full transition-all duration-200 relative",
            if(@cool_on, do: "bg-sky-500", else: "bg-base-300")
          ]}>
            <div class={[
              "absolute top-0.5 h-5 w-5 rounded-full bg-white shadow-sm transition-all duration-200",
              if(@cool_on, do: "left-[22px]", else: "left-0.5")
            ]} />
          </div>
        </button>
      </div>

      <%!-- Readings + target row --%>
      <div class="grid grid-cols-2 gap-3">
        <%!-- Current readings card --%>
        <div class="flex flex-col justify-center gap-3 rounded-2xl border-2 border-base-300 bg-base-200 px-5 py-4">
          <div class="flex items-baseline gap-1">
            <span class="text-4xl font-bold tabular-nums text-base-content leading-none">
              {if is_nil(@thermostat.temperature),
                do: "—",
                else: Float.round(@thermostat.temperature, 1)}
            </span>
            <span class="text-lg text-base-content/50 leading-none">°C</span>
          </div>
          <div class="flex items-center gap-2 text-base-content/50">
            <svg
              class="w-4 h-4 shrink-0 fill-sky-400"
              viewBox="0 0 24 24"
              xmlns="http://www.w3.org/2000/svg"
            >
              <path d="M12 2C9.24 2 7 4.24 7 7c0 3.53 3.84 8.25 4.33 8.82a.85.85 0 0 0 1.34 0C13.16 15.25 17 10.53 17 7c0-2.76-2.24-5-5-5zm0 8.5A2.5 2.5 0 0 1 9.5 8a2.5 2.5 0 0 1 5 0A2.5 2.5 0 0 1 12 10.5z" />
              <path
                d="M12 16c-3.31 0-6 .9-6 2s2.69 2 6 2 6-.9 6-2-2.69-2-6-2z"
                opacity=".3"
              />
            </svg>
            <span class="text-sm tabular-nums font-medium">
              {if is_nil(@thermostat.humidity),
                do: "—",
                else: "#{@thermostat.humidity |> Float.round(0) |> trunc()}%"} humidity
            </span>
          </div>
        </div>

        <%!-- Target temperature card — hidden when off --%>
        <%= if @active do %>
          <div class="flex flex-col items-center justify-between rounded-2xl border-2 border-base-300 bg-base-200 px-3 py-3 gap-1">
            <span class="text-xs uppercase tracking-widest font-semibold text-base-content/40">
              Target
            </span>

            <button
              id="thermostat-target-up"
              class={[
                "flex items-center justify-center w-full rounded-xl py-3 transition-colors duration-150 touch-manipulation active:scale-95",
                if(@cool_on,
                  do: "bg-sky-500/15 active:bg-sky-500/30 text-sky-500",
                  else: "bg-orange-500/15 active:bg-orange-500/30 text-orange-500"
                )
              ]}
              phx-click="target_adjust"
              phx-value-amount={@adjustment_amount}
              phx-target={@myself}
            >
              <svg
                class="w-7 h-7"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                stroke-width="2.5"
                stroke-linecap="round"
                stroke-linejoin="round"
              >
                <polyline points="18 15 12 9 6 15" />
              </svg>
            </button>

            <span class={[
              "text-3xl font-bold tabular-nums leading-none transition-colors duration-200",
              @target_color || "text-base-content"
            ]}>
              {Float.round(@thermostat.target, 1)}°
            </span>

            <button
              id="thermostat-target-down"
              class={[
                "flex items-center justify-center w-full rounded-xl py-3 transition-colors duration-150 touch-manipulation active:scale-95",
                if(@cool_on,
                  do: "bg-sky-500/15 active:bg-sky-500/30 text-sky-500",
                  else: "bg-orange-500/15 active:bg-orange-500/30 text-orange-500"
                )
              ]}
              phx-click="target_adjust"
              phx-value-amount={-@adjustment_amount}
              phx-target={@myself}
            >
              <svg
                class="w-7 h-7"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                stroke-width="2.5"
                stroke-linecap="round"
                stroke-linejoin="round"
              >
                <polyline points="6 9 12 15 18 9" />
              </svg>
            </button>
          </div>
        <% else %>
          <div class="flex flex-col items-center justify-center rounded-2xl border-2 border-dashed border-base-300 px-3 py-4 gap-1 opacity-40">
            <span class="text-xs uppercase tracking-widest font-semibold text-base-content/60">
              Target
            </span>
            <span class="text-3xl font-bold tabular-nums text-base-content/40">
              {Float.round(@thermostat.target, 1)}°
            </span>
            <span class="text-xs text-base-content/40">off</span>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  defp target_color(%{mode: :heat, target: target, temperature: temp}) when target > temp,
    do: "text-orange-500"

  defp target_color(%{mode: :cool, target: target, temperature: temp}) when target < temp,
    do: "text-sky-500"

  defp target_color(_), do: nil
end

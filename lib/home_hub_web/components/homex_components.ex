defmodule HomeHubWeb.HomexComponents do
  @moduledoc false
  use HomeHubWeb, :live_component

  alias HomeHubWeb.AppComponents

  attr :sensor, :map, required: true, doc: "map with keys: name, temperature, humidity, battery"

  def sensor_widget(assigns) do
    ~H"""
    <div class="relative flex flex-col gap-3 rounded-2xl bg-base-200 border border-base-300 px-4 py-3 w-52 shadow-sm hover:shadow-md transition-shadow duration-200">
      <div class="flex items-center justify-between">
        <span class="text-sm font-semibold text-base-content truncate">{@sensor.name}</span>
        <span class={[
          "flex items-center gap-1 text-xs font-medium px-1.5 py-0.5 rounded-full",
          cond do
            is_nil(@sensor.battery) -> "bg-base-300 text-base-content/40"
            @sensor.battery > 50 -> "bg-emerald-500/15 text-emerald-400"
            @sensor.battery > 20 -> "bg-amber-500/15 text-amber-400"
            true -> "bg-red-500/15 text-red-400"
          end
        ]}>
          <svg class="w-3 h-3" viewBox="0 0 24 24" fill="currentColor">
            <path d="M15.67 4H14V2h-4v2H8.33C7.6 4 7 4.6 7 5.33v15.33C7 21.4 7.6 22 8.33 22h7.33C16.4 22 17 21.4 17 20.67V5.33C17 4.6 16.4 4 15.67 4z" />
          </svg>
          <%= if is_nil(@sensor.battery) do %>
            —
          <% else %>
            {@sensor.battery}%
          <% end %>
        </span>
      </div>

      <div class="grid grid-cols-2 gap-2">
        <div class="flex flex-col items-center justify-center rounded-xl bg-base-100 py-2 px-1">
          <span class="text-xs text-base-content/50 mb-0.5">Temp</span>
          <span class="text-lg font-bold text-orange-400 leading-none">{@sensor.temperature}°</span>
          <span class="text-[10px] text-base-content/40 mt-0.5">Celsius</span>
        </div>
        <div class="flex flex-col items-center justify-center rounded-xl bg-base-100 py-2 px-1">
          <span class="text-xs text-base-content/50 mb-0.5">Humidity</span>
          <span class="text-lg font-bold text-sky-400 leading-none">{@sensor.humidity}%</span>
          <span class="text-[10px] text-base-content/40 mt-0.5">Relative</span>
        </div>
      </div>
    </div>
    """
  end

  attr :name, :string, required: true
  attr :event, :string, required: true
  attr :rest, :global, include: ~w(disabled form name value)
  slot :inner_block, required: true

  def homex_button(assigns) do
    ~H"""
    <button
      type="button"
      aria-label=""
      class="btn btn-xl p-8 btn-primary rounded-selector"
      phx-click="homex_button_press"
      phx-value-name={@name}
      phx-value-event={@event}
      {@rest}
    >
      {render_slot(@inner_block)}
    </button>
    """
  end

  @icon_size "h-10 w-10"
  @icon_margin "mr-3"

  Enum.each(~w(lamp exit sunrise), fn icon_name ->
    attr :icon_size, :string, default: @icon_size
    attr :icon_margin, :string, default: @icon_margin
    attr :class, :string, default: nil

    @function :"#{icon_name}_icon"

    def unquote(:"hap_icon_#{icon_name}")(assigns) do
      apply(AppComponents, @function, [assign_merge(assigns, :class, [:icon_margin])])
    end
  end)

  def assign_merge(assigns, key, keys) do
    assign(assigns, key, assigns |> Map.take(keys ++ [key]) |> Map.values() |> Enum.to_list())
  end
end

defmodule HomeHubWeb.HAPButtonComponents do
  @moduledoc false
  use HomeHubWeb, :live_component

  alias HomeHubWeb.AppComponents

  attr :name, :string, required: true
  attr :event, :string, required: true
  attr :rest, :global, include: ~w(disabled form name value)
  slot :inner_block, required: true

  def hap_button(assigns) do
    ~H"""
    <button
      type="button"
      aria-label=""
      class="inline-block px-10 py-6 bg-blue-600 text-white text-2xl leading-tight rounded shadow-md hover:bg-blue-700 hover:shadow-lg focus:bg-blue-700 focus:shadow-lg focus:outline-none focus:ring-0 active:bg-blue-800 active:shadow-lg transition duration-150 ease-in-out"
      phx-click="hap_press"
      phx-value-name={@name}
      phx-value-event={@event}
      {@rest}
    >
      <div class="flex">
        {render_slot(@inner_block)}
      </div>
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

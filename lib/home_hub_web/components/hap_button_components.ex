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
      class="btn btn-xl p-8 btn-primary rounded-selector"
      phx-click="hap_press"
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

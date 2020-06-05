defmodule HomeHub.IO.LightTest do
  use ExUnit.Case, async: true

  # When testing helpers, you may want to import Phoenix.HTML and
  # use functions such as safe_to_string() to convert the helper
  # result into an HTML string.
  # import Phoenix.HTML
  describe "percent_to_level/2 with inverted power control" do
    setup do
      {:ok, [light: %Light{frequency: 300, inverted: true}]}
    end

    test "all on", %{light: light} do
      freq = Light.percent_to_level(light, 100)
      assert freq == light.visible_frequency
    end

    test "all off", %{light: light} do
      freq = Light.percent_to_level(light, 0)
      assert freq == light.frequency
    end
  end
end

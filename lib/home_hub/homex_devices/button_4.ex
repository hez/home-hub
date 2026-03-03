defmodule HomeHub.HomexDevice.Button4 do
  use Homex.Entity.DeviceTrigger, name: "button-4", subtype: "button_4"

  def trigger, do: GenServer.cast(:button4, {:push_value, :trigger, "action", false})
end

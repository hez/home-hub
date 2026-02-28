defmodule HomeHub.HomexDevice.Button6 do
  use Homex.Entity.DeviceTrigger, name: "button-6", subtype: "button_6"

  def trigger, do: GenServer.cast(:button6, {:push_value, :trigger, "action"})
end

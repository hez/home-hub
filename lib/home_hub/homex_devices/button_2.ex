defmodule HomeHub.HomexDevice.Button2 do
  use Homex.Entity.DeviceTrigger, name: "button-2", subtype: "button_2"

  def trigger, do: GenServer.cast(:button2, {:push_value, :trigger, "action"})
end

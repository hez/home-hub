defmodule HomeHub do
  @moduledoc """
  `HomeHub`

  ```mermaid
  sequenceDiagram
    participant Temperature Sensor
    participant Dashboard
    participant PubSub
    participant Thermostat
    participant Reporter
    participant Heater IO
    Temperature Sensor->>PubSub: %{temperature: new_t, humidity: new_h}
    PubSub->>Thermostat: New temperature/humidity
    activate Thermostat
    Thermostat->>Thermostat: Update current temperature/humidity
    Thermostat->>PubSub: New Thermostat state
    deactivate Thermostat
    loop every @poll_interval
    activate Thermostat
      Thermostat->>Thermostat: Update Pid
      Thermostat->>Thermostat: Update State from Pid
      Thermostat->>PubSub: Heater state update
      Thermostat->>PubSub: Fan state update
      Thermostat->>PubSub: New Thermostat state
    deactivate Thermostat
    end
    PubSub->>Reporter: New temperature/humidity
    activate Reporter
    Reporter->>Reporter: ReportingConnection.write
    deactivate Reporter
    PubSub->>Heater IO: New heater/fan state
    activate Heater IO
    Heater IO->>Heater IO: Turn on or off heater/fan pins
    deactivate Heater IO
    PubSub->>Dashboard: Thermostat state
    activate Dashboard
    Dashboard->>Dashboard: Update current temperature/humidity
    deactivate Dashboard
    Dashboard->>Thermostat: adjust_target_by
  ```
  """
end

defmodule HomeHub.PhosconTest do
  use ExUnit.Case, async: true
  alias HomeHub.Phoscon

  @sample_data %{
    "27" => %{
      "config" => %{
        "battery" => 80,
        "on" => true,
        "pending" => [],
        "reachable" => true
      },
      "ep" => 1,
      "lastannounced" => "2022-09-05T04:27:49Z",
      "lastseen" => "2022-12-29T15:51Z",
      "manufacturername" => "LUMI",
      "mode" => 1,
      "modelid" => "lumi.remote.b686opcn01",
      "name" => "livingroom-switch",
      "state" => %{
        "buttonevent" => 2002,
        "lastupdated" => "2022-12-29T15:51:11.201"
      },
      "swversion" => "2019",
      "type" => "ZHASwitch"
    },
    "36" => %{
      "config" => %{"on" => true, "reachable" => true, "temperature" => 0},
      "ep" => 1,
      "lastannounced" => "2022-11-06T19:46:39Z",
      "lastseen" => "2022-12-29T16:39Z",
      "manufacturername" => "LUMI",
      "modelid" => "lumi.switch.b1naus01",
      "name" => "Consumption 36",
      "state" => %{
        "consumption" => 2929,
        "lastupdated" => "2022-12-29T16:37:11.456"
      },
      "swversion" => "09-06-2019",
      "type" => "ZHAConsumption"
    },
    "44" => %{
      "config" => %{
        "battery" => 85,
        "offset" => 0,
        "on" => true,
        "reachable" => true
      },
      "ep" => 1,
      "lastannounced" => nil,
      "lastseen" => "2022-12-29T16:07Z",
      "manufacturername" => "LUMI",
      "modelid" => "lumi.weather",
      "name" => "attic-temp",
      "state" => %{
        "lastupdated" => "2022-12-29T16:07:52.341",
        "temperature" => 764
      },
      "swversion" => "20191205",
      "type" => "ZHATemperature"
    },
    "52" => %{
      "config" => %{
        "battery" => 88,
        "offset" => 0,
        "on" => true,
        "reachable" => true
      },
      "ep" => 1,
      "lastannounced" => nil,
      "lastseen" => "2022-12-29T16:16Z",
      "manufacturername" => "LUMI",
      "modelid" => "lumi.weather",
      "name" => "furnace-temp",
      "state" => %{"lastupdated" => "2022-12-29T16:16:40.264", "pressure" => 997},
      "swversion" => "20191205",
      "type" => "ZHAPressure"
    },
    "58" => %{
      "config" => %{
        "battery" => 81,
        "offset" => 0,
        "on" => true,
        "reachable" => true
      },
      "ep" => 1,
      "lastannounced" => nil,
      "lastseen" => "2022-12-29T16:38Z",
      "manufacturername" => "LUMI",
      "modelid" => "lumi.weather",
      "name" => "outside-temp",
      "state" => %{"lastupdated" => "2022-12-29T16:38:58.245", "pressure" => 997},
      "swversion" => "20191205",
      "type" => "ZHAPressure"
    },
    "56" => %{
      "config" => %{
        "battery" => 81,
        "offset" => 0,
        "on" => true,
        "reachable" => true
      },
      "ep" => 1,
      "lastannounced" => nil,
      "lastseen" => "2022-12-29T16:38Z",
      "manufacturername" => "LUMI",
      "modelid" => "lumi.weather",
      "name" => "outside-temp",
      "state" => %{
        "lastupdated" => "2022-12-29T16:38:58.234",
        "temperature" => 705
      },
      "swversion" => "20191205",
      "type" => "ZHATemperature"
    },
    "45" => %{
      "config" => %{
        "battery" => 85,
        "offset" => 0,
        "on" => true,
        "reachable" => true
      },
      "ep" => 1,
      "lastannounced" => nil,
      "lastseen" => "2022-12-29T16:07Z",
      "manufacturername" => "LUMI",
      "modelid" => "lumi.weather",
      "name" => "attic-temp",
      "state" => %{"humidity" => 8737, "lastupdated" => "2022-12-29T16:07:52.360"},
      "swversion" => "20191205",
      "type" => "ZHAHumidity"
    },
    "12" => %{
      "config" => %{
        "battery" => 100,
        "duration" => 90,
        "on" => true,
        "reachable" => true,
        "temperature" => 1900
      },
      "ep" => 1,
      "lastannounced" => "2021-10-08T02:04:03Z",
      "lastseen" => "2022-12-29T16:22Z",
      "manufacturername" => "LUMI",
      "modelid" => "lumi.sensor_motion.aq2",
      "name" => "taproom-motion",
      "state" => %{
        "lastupdated" => "2022-12-29T16:23:35.541",
        "presence" => false
      },
      "swversion" => "20170627",
      "type" => "ZHAPresence"
    },
    "10" => %{
      "config" => %{
        "battery" => 85,
        "on" => true,
        "reachable" => true,
        "temperature" => 2300
      },
      "ep" => 1,
      "lastannounced" => nil,
      "lastseen" => "2022-12-29T15:50Z",
      "manufacturername" => "LUMI",
      "modelid" => "lumi.sensor_magnet.aq2",
      "name" => "front-door",
      "state" => %{"lastupdated" => "2022-12-29T15:50:25.527", "open" => false},
      "swversion" => "20161128",
      "type" => "ZHAOpenClose"
    },
    "18" => %{
      "config" => %{
        "battery" => 100,
        "enrolled" => 0,
        "on" => true,
        "pending" => [],
        "reachable" => true,
        "temperature" => 2000
      },
      "ep" => 1,
      "lastannounced" => nil,
      "lastseen" => "2022-12-29T16:15Z",
      "manufacturername" => "LUMI",
      "modelid" => "lumi.sensor_wleak.aq1",
      "name" => "furnace-water",
      "state" => %{
        "lastupdated" => "2022-12-29T16:15:24.540",
        "lowbattery" => false,
        "tampered" => false,
        "water" => false
      },
      "swversion" => "20170721",
      "type" => "ZHAWater"
    },
    "50" => %{
      "config" => %{
        "battery" => 88,
        "offset" => 0,
        "on" => true,
        "reachable" => true
      },
      "ep" => 1,
      "lastannounced" => nil,
      "lastseen" => "2022-12-29T16:16Z",
      "manufacturername" => "LUMI",
      "modelid" => "lumi.weather",
      "name" => "furnace-temp",
      "state" => %{
        "lastupdated" => "2022-12-29T16:16:40.236",
        "temperature" => 1889
      },
      "swversion" => "20191205",
      "type" => "ZHATemperature"
    },
    "41" => %{
      "config" => %{
        "battery" => 85,
        "offset" => 0,
        "on" => true,
        "reachable" => true
      },
      "ep" => 1,
      "lastannounced" => "2022-07-25T22:29:02Z",
      "lastseen" => "2022-12-29T16:38Z",
      "manufacturername" => "LUMI",
      "modelid" => "lumi.weather",
      "name" => "bathroom-temp",
      "state" => %{
        "lastupdated" => "2022-12-29T16:38:46.116",
        "temperature" => 1846
      },
      "swversion" => "20161129",
      "type" => "ZHATemperature"
    },
    "46" => %{
      "config" => %{
        "battery" => 85,
        "offset" => 0,
        "on" => true,
        "reachable" => true
      },
      "ep" => 1,
      "lastannounced" => nil,
      "lastseen" => "2022-12-29T16:07Z",
      "manufacturername" => "LUMI",
      "modelid" => "lumi.weather",
      "name" => "attic-temp",
      "state" => %{"lastupdated" => "2022-12-29T16:07:52.371", "pressure" => 998},
      "swversion" => "20191205",
      "type" => "ZHAPressure"
    },
    "35" => %{
      "config" => %{"battery" => 100, "on" => true, "reachable" => true},
      "ep" => 1,
      "lastannounced" => nil,
      "lastseen" => "2022-12-29T15:57Z",
      "manufacturername" => "LUMI",
      "mode" => 1,
      "modelid" => "lumi.sensor_switch",
      "name" => "livingroom-table",
      "state" => %{
        "buttonevent" => 1002,
        "lastupdated" => "2022-12-29T00:40:07.194"
      },
      "type" => "ZHASwitch"
    },
    "59" => %{
      "config" => %{"battery" => 100, "on" => true, "reachable" => true},
      "ep" => 1,
      "lastannounced" => nil,
      "lastseen" => "2022-12-29T16:23Z",
      "manufacturername" => "LUMI",
      "mode" => 1,
      "modelid" => "lumi.sensor_switch",
      "name" => "office button",
      "state" => %{
        "buttonevent" => 1003,
        "lastupdated" => "2022-12-23T06:30:29.532"
      },
      "type" => "ZHASwitch"
    },
    "57" => %{
      "config" => %{
        "battery" => 81,
        "offset" => 0,
        "on" => true,
        "reachable" => true
      },
      "ep" => 1,
      "lastannounced" => nil,
      "lastseen" => "2022-12-29T16:38Z",
      "manufacturername" => "LUMI",
      "modelid" => "lumi.weather",
      "name" => "outside-temp",
      "state" => %{"humidity" => 8739, "lastupdated" => "2022-12-29T16:38:58.242"},
      "swversion" => "20191205",
      "type" => "ZHAHumidity"
    },
    "42" => %{
      "config" => %{
        "battery" => 85,
        "offset" => 0,
        "on" => true,
        "reachable" => true
      },
      "ep" => 1,
      "lastannounced" => "2022-07-25T22:29:02Z",
      "lastseen" => "2022-12-29T16:38Z",
      "manufacturername" => "LUMI",
      "modelid" => "lumi.weather",
      "name" => "bathroom-temp",
      "state" => %{"humidity" => 5792, "lastupdated" => "2022-12-29T16:38:46.127"},
      "swversion" => "20161129",
      "type" => "ZHAHumidity"
    },
    "13" => %{
      "config" => %{
        "battery" => 100,
        "on" => true,
        "reachable" => true,
        "temperature" => 1900,
        "tholddark" => 12_000,
        "tholdoffset" => 7000
      },
      "ep" => 1,
      "lastannounced" => "2021-10-08T02:04:03Z",
      "lastseen" => "2022-12-29T16:22Z",
      "manufacturername" => "LUMI",
      "modelid" => "lumi.sensor_motion.aq2",
      "name" => "taproom-motion",
      "state" => %{
        "dark" => true,
        "daylight" => false,
        "lastupdated" => "2022-12-29T16:22:05.164",
        "lightlevel" => 0,
        "lux" => 0
      },
      "swversion" => "20170627",
      "type" => "ZHALightLevel"
    },
    "51" => %{
      "config" => %{
        "battery" => 88,
        "offset" => 0,
        "on" => true,
        "reachable" => true
      },
      "ep" => 1,
      "lastannounced" => nil,
      "lastseen" => "2022-12-29T16:16Z",
      "manufacturername" => "LUMI",
      "modelid" => "lumi.weather",
      "name" => "furnace-temp",
      "state" => %{"humidity" => 5398, "lastupdated" => "2022-12-29T16:16:40.251"},
      "swversion" => "20191205",
      "type" => "ZHAHumidity"
    },
    "9" => %{
      "config" => %{"on" => true, "reachable" => true, "temperature" => 0},
      "ep" => 1,
      "lastannounced" => "2022-11-06T19:46:41Z",
      "lastseen" => "2022-12-29T16:38Z",
      "manufacturername" => "LUMI",
      "modelid" => "lumi.switch.b1naus01",
      "name" => "Power 9",
      "state" => %{"lastupdated" => "2022-12-29T16:39:04.392", "power" => 0},
      "swversion" => "09-06-2019",
      "type" => "ZHAPower"
    }
  }

  describe "parse_results/1" do
    setup do
      [parsed_data: Phoscon.parse_results(@sample_data)]
    end

    test "keys for all sensors with data", %{parsed_data: parsed_data} do
      assert Map.keys(parsed_data) == [
               "Consumption 36",
               "Power 9",
               "attic-temp",
               "bathroom-temp",
               "front-door",
               "furnace-temp",
               "furnace-water",
               "livingroom-switch",
               "livingroom-table",
               "office button",
               "outside-temp",
               "taproom-motion"
             ]
    end

    test "parsing pulls out known sensor data", %{parsed_data: parsed_data} do
      assert parsed_data["outside-temp"] == %{
               battery: 81,
               lastseen: ~U[2022-12-29 16:38:00Z],
               humidity: 87.39,
               pressure: 997,
               temperature: 7.05
             }
    end
  end
end

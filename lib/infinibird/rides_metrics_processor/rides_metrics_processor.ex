defmodule Infinibird.RidesMetricsProcessor do

  def prepare_summary_data(data) do
      rides_data = Map.get(data, "rides_data", [])

      IO.inspect(rides_data)

     %{
        distance_meters: Enum.reduce(rides_data, 0, fn e, acc -> acc + e["distance_m"] end ),
        number_of_trips: length(rides_data),
        average_speed: get_avg_speed(rides_data),
        max_speed: Enum.max_by(rides_data, fn e -> e["max_speed_kmh"] end)["max_speed_kmh"],
        travel_time_minutes: Enum.reduce(rides_data, 0, fn e, acc -> acc + e["travel_time_minutes"] end),
        longest_ride: Enum.max_by(rides_data, fn e -> e["distance_m"] end)["distance_m"],
      }
  end


  defp get_avg_speed(rides_data) do
    speed = Enum.reduce(rides_data, 0, fn e, acc -> acc + e["avg_speed_kmh"] end )
    number_of_trips = length(rides_data)


    Kernel.round(speed / number_of_trips)
  end
end

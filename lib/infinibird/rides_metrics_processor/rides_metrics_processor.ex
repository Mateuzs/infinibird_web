defmodule Infinibird.RidesMetricsProcessor do

  def prepare_summary_data(data) do
      rides_data = Map.get(data, "rides_data", [])



     %{
        distance_meters: Enum.reduce(rides_data, 0, fn e, acc -> acc + e["distance_m"] end),
        number_of_trips: length(rides_data),
        average_speed: get_avg_speed(rides_data),
        max_speed: Enum.max_by(rides_data, fn e -> e["max_speed_kmh"] end)["max_speed_kmh"],
        max_acceleration: Enum.max_by(rides_data, fn e -> e["max_acceleration_ms"] end)["max_acceleration_ms"],
        travel_time_minutes: Enum.reduce(rides_data, 0, fn e, acc -> acc + e["travel_time_minutes"] end),
        longest_ride: Enum.max_by(rides_data, fn e -> e["distance_m"] end)["distance_m"],
        most_famous_day: get_most_famous_day(rides_data),
        most_famous_time_of_day: get_most_famous_time_of_day(rides_data)
      }
  end


  defp get_avg_speed(rides_data) do
    speed = Enum.reduce(rides_data, 0, fn e, acc -> acc + e["avg_speed_kmh"] end )
    number_of_trips = length(rides_data)


    Kernel.round(speed / number_of_trips)
  end

  defp get_most_famous_day(rides_data) do
    {most_famous_day, _rides} = Enum.group_by(rides_data, fn e ->  e["day"] end) |> Map.to_list() |> Enum.max_by(fn {_k,v} -> length(v) end)

    most_famous_day
  end

  defp get_most_famous_time_of_day(rides_data) do
    {most_famous_time_of_day, _rides} = Enum.group_by(rides_data, fn e ->  e["time_of_day"] end) |> Map.to_list() |> Enum.max_by(fn {_k,v} -> length(v) end)

    most_famous_time_of_day
  end
end

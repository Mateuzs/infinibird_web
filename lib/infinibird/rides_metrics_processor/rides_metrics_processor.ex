defmodule Infinibird.RidesMetricsProcessor do
  alias Infinibird.ChartsConfig
  alias Infinibird.RideMetrics

  @spec prepare_summary_data([%RideMetrics{}]) :: %{
          average_speed: integer,
          distance_meters: integer,
          longest_ride: integer,
          max_acceleration: float,
          max_speed: integer,
          most_famous_day: String.t(),
          most_famous_time_of_day: String.t(),
          number_of_trips: integer,
          travel_time_minutes: integer
        }

  def prepare_summary_data(rides_data) do
    %{
      distance_meters: Enum.reduce(rides_data, 0, fn e, acc -> acc + e["distance_m"] end),
      number_of_trips: length(rides_data),
      average_speed: get_avg_speed(rides_data),
      max_speed: Enum.max_by(rides_data, fn e -> e["max_speed_kmh"] end)["max_speed_kmh"],
      max_acceleration:
        Enum.max_by(rides_data, fn e -> e["max_acceleration_ms"] end)["max_acceleration_ms"],
      travel_time_minutes:
        Enum.reduce(rides_data, 0, fn e, acc -> acc + e["travel_time_minutes"] end),
      longest_ride: Enum.max_by(rides_data, fn e -> e["distance_m"] end)["distance_m"],
      most_famous_day: get_most_famous_day(rides_data),
      most_famous_time_of_day: get_most_famous_time_of_day(rides_data)
    }
  end

  @spec prepare_charts_data([%RideMetrics{}]) :: map
  def prepare_charts_data(rides_metrics) do
    charts_config = ChartsConfig.get_charts_config()

    column_charts = get_charts_data(rides_metrics, charts_config, :column_charts)
    line_charts = get_charts_data(rides_metrics, charts_config, :line_charts)
    area_charts = get_charts_data(rides_metrics, charts_config, :area_charts)
    pie_charts = get_charts_data(rides_metrics, charts_config, :pie_charts)

    Map.update!(charts_config, :column_charts, fn _pv -> column_charts end)
    |> Map.update!(:line_charts, fn _pv -> line_charts end)
    |> Map.update!(:area_charts, fn _pv -> area_charts end)
    |> Map.update!(:pie_charts, fn _pv -> pie_charts end)
  end

  defp get_charts_data(rides_metrics, charts_config, chart_type) do
    charts_config[chart_type]
    |> Enum.map(fn config ->
      data = config.data_extractor.(rides_metrics)

      Map.drop(config, [:data_extractor]) |> Map.put(:data, data)
    end)
  end

  defp get_avg_speed(rides_data) do
    speed = Enum.reduce(rides_data, 0, fn e, acc -> acc + e["avg_speed_kmh"] end)
    number_of_trips = length(rides_data)

    Kernel.round(speed / number_of_trips)
  end

  defp get_most_famous_day(rides_data) do
    {most_famous_day, _rides} =
      Enum.group_by(rides_data, fn e -> e["day"] end)
      |> Map.to_list()
      |> Enum.max_by(fn {_k, v} -> length(v) end)

    most_famous_day
  end

  defp get_most_famous_time_of_day(rides_data) do
    {most_famous_time_of_day, _rides} =
      Enum.group_by(rides_data, fn e -> e["time_of_day"] end)
      |> Map.to_list()
      |> Enum.max_by(fn {_k, v} -> length(v) end)

    most_famous_time_of_day
  end
end

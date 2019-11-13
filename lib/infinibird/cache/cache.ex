defmodule Infinibird.Cache do
  require Logger
  alias Infinibird.RidesMetricsProcessor
  alias Infinibird.DataProvider
  @data_expiration_time 120

  @spec get(String.t(), atom, List.atom()) :: any
  def get(device_id, data_type, opts \\ []) do
    case lookup(device_id, data_type) do
      nil ->
        ttl = Keyword.get(opts, :ttl, @data_expiration_time)
        cache_apply(device_id, data_type, ttl)

      result ->
        Logger.info("reading data from cache")
        result
    end
  end

  defp lookup(device_id, data_type) do
    case :ets.lookup(:infinibird_cache, [device_id, data_type]) do
      [result | _] -> check_freshness(result)
      [] -> nil
    end
  end

  defp check_freshness({_key, result, expiration}) do
    cond do
      expiration > :os.system_time(:seconds) -> result
      :else -> nil
    end
  end

  defp cache_apply(device_id, data_type, ttl) do
    Logger.info("fetching data from infinibird_service")

    processed_data =
      case data_type do
        type when type === :summary or type === :charts ->
          rides_metrics = DataProvider.get_rides_metrics(device_id)

          charts = RidesMetricsProcessor.prepare_charts_data(rides_metrics)
          summary = RidesMetricsProcessor.prepare_summary_data(rides_metrics)

          charts_expiration = get_expiration_time(charts, ttl)
          summary_expiration = get_expiration_time(summary, ttl)

          :ets.insert(:infinibird_cache, {[device_id, :charts], charts, charts_expiration})
          :ets.insert(:infinibird_cache, {[device_id, :summary], summary, summary_expiration})

          case data_type do
            :charts -> charts
            :summary -> summary
          end

        _type ->
          Logger.error("Unrecognized data type!")
      end

    processed_data
  end

  @spec delete(String.t()) :: true
  def delete(device_id) do
    :ets.delete(:infinibird_cache, [device_id, :summary])
    :ets.delete(:infinibird_cache, [device_id, :charts])
  end

  defp get_expiration_time(processed_data, ttl) do
    case processed_data do
      map when map == %{} -> :os.system_time(:seconds)
      _map -> :os.system_time(:seconds) + ttl
    end
  end
end

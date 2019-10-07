defmodule Infinibird.Cache do
  require Logger
  alias Infinibird.RidesMetricsProcessor

  def get(device_id, data_type, opts \\ []) do
    case lookup(device_id, data_type) do
      nil ->
        ttl = Keyword.get(opts, :ttl, 120)
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
    [username: username, password: password, realm: _realm] =
      Application.get_env(:infinibird, :infinibird_service_basic_auth_config)

    credentials = "#{username}:#{password}" |> Base.encode64()

    Logger.info("fetching data from infinibird_service")

    processed_data =
      case data_type do
        :summary ->
          HTTPoison.get(
            "#{Application.get_env(:infinibird, :infinibird_service_url)}/infinibird/rides_metrics/#{
              device_id
            }",
            [{"content-type", "application/bson"}, {"Authorization", "Basic #{credentials}"}]
          )
          |> case do
            {:error, _error} ->
              Logger.error("Cannot connect to infinibird_service!")
              %{}

            {:ok, response} ->
              Logger.info("fetched data from infinibird_service")
              result = Jason.decode!(response.body)

              RidesMetricsProcessor.prepare_summary_data(result)
          end

        :charts ->
          HTTPoison.get(
            "#{Application.get_env(:infinibird, :infinibird_service_url)}/infinibird/rides_metrics/#{
              device_id
            }",
            [{"content-type", "application/bson"}, {"Authorization", "Basic #{credentials}"}]
          )
          |> case do
            {:error, _error} ->
              Logger.error("Cannot connect to infinibird_service!")
              %{}

            {:ok, response} ->
              Logger.info("fetched data from infinibird_service")
              result = Jason.decode!(response.body) |>  Map.get("charts", [])

             result
          end

        :trips ->
          HTTPoison.get(
            "#{Application.get_env(:infinibird, :infinibird_service_url)}/infinibird/trips/#{
              device_id
            }",
            [{"content-type", "application/bson"}, {"Authorization", "Basic #{credentials}"}]
          )
          |> case do
            {:error, _error} ->
              Logger.error("Cannot connect to infinibird_service!")
              %{}

            {:ok, response} ->
              Logger.info("fetched data from infinibird_service")
              response.body
          end
      end

    expiration =
      case processed_data do
        map when map == %{} -> :os.system_time(:seconds)
        _map -> :os.system_time(:seconds) + ttl
      end


    IO.inspect(processed_data)
    IO.puts("dupsko")
    :ets.insert(:infinibird_cache, {[device_id, data_type], processed_data, expiration})

    processed_data
  end

  def delete(device_id) do
    :ets.delete(:infinibird_cache, [device_id, :trips])
    :ets.delete(:infinibird_cache, [device_id, :summary])
    :ets.delete(:infinibird_cache, [device_id, :charts])

  end
end

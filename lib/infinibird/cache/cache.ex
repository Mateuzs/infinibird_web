defmodule Infinibird.Cache do
  require Logger

  def get(user_id, data_type, opts \\ []) do
    case lookup(user_id, data_type) do
      nil ->
        ttl = Keyword.get(opts, :ttl, 120)
        cache_apply(user_id, data_type, ttl)

      result ->
        Logger.info("reading data from cache")
        result
    end
  end

  defp lookup(user_id, data_type) do
    case :ets.lookup(:infinibird_cache, [user_id, data_type]) do
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

  defp cache_apply(user_id, data_type, ttl) do
    [username: username, password: password, realm: _realm] =
      Application.get_env(:infinibird, :infinibird_service_basic_auth_config)

    credentials = "#{username}:#{password}" |> Base.encode64()

    Logger.info("fetching data from infinibird_service")

    {:ok, response} =
      case data_type do
        :summary ->
          HTTPoison.get(
            "#{Application.get_env(:infinibird, :infinibird_service_url)}/infinibird/summary",
            [{"content-type", "application/json"}, {"Authorization", "Basic #{credentials}"}]
          )
          |> case do
            {:error, _error} ->
              Logger.error("Cannot connect to infinibird_service!")
              {:ok, %{}}

            {:ok, response} ->
              Logger.info("fetched data from infinibird_service")
              {:ok, response}
          end

        :trips ->
          HTTPoison.get(
            "#{Application.get_env(:infinibird, :infinibird_service_url)}/infinibird/trips",
            [{"content-type", "application/json"}, {"Authorization", "Basic #{credentials}"}]
          )
          |> case do
            {:error, _error} ->
              Logger.error("Cannot connect to infinibird_service!")
              {:ok, %{}}

            {:ok, response} ->
              Logger.info("fetched data from infinibird_service")
              {:ok, response}
          end
      end

    expiration =
      case response do
        map when map == %{} -> :os.system_time(:seconds)
        _map -> :os.system_time(:seconds) + ttl
      end

    result = Map.get(response, :body, %{})

    :ets.insert(:infinibird_cache, {[user_id, data_type], result, expiration})

    Logger.info(:ets.info(:infinibird_cache, :size))
    result
  end

  def delete(user_id) do
    :ets.delete(:infinibird_cache, [user_id, :trips])
    :ets.delete(:infinibird_cache, [user_id, :summary])
  end
end

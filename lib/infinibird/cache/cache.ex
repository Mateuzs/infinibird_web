defmodule Infinibird.Cache do
  def get(user_id, data_type, opts \\ []) do
    case lookup(user_id, data_type) do
      nil ->
        ttl = Keyword.get(opts, :ttl, 120)
        cache_apply(user_id, data_type, ttl)

      result ->
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

    {:ok, response} =
      case data_type do
        :summary ->
          HTTPoison.get(
            "localhost:4000/infinibird/summary",
            [{"content-type", "application/json"}, {"Authorization", "Basic #{credentials}"}]
          )

        :trips ->
          HTTPoison.get(
            "localhost:4000/infinibird/trips",
            [{"content-type", "application/json"}, {"Authorization", "Basic #{credentials}"}]
          )
      end

    expiration = :os.system_time(:seconds) + ttl

    :ets.insert(:infinibird_cache, {[user_id, data_type], result, expiration})

    result
  end
end

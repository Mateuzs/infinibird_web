defmodule Infinibird.DataProvider do
  require Logger

  @spec get_rides_metrics(String.t()) :: list(RidesMetrics)
  def get_rides_metrics(device_id) do
    [username: username, password: password, realm: _realm] =
      Application.get_env(:infinibird, :infinibird_service_basic_auth_config)

    credentials = "#{username}:#{password}" |> Base.encode64()

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

        Jason.decode!(response.body)
    end
  end

  @spec get_trips(String.t()) :: list()
  def get_trips(device_id) do
    [username: username, password: password, realm: _realm] =
      Application.get_env(:infinibird, :infinibird_service_basic_auth_config)

    credentials = "#{username}:#{password}" |> Base.encode64()

    HTTPoison.get(
      "#{Application.get_env(:infinibird, :infinibird_service_url)}/infinibird/trips/#{device_id}",
      [{"content-type", "application/bson"}, {"Authorization", "Basic #{credentials}"}]
    )
    |> case do
      {:error, _error} ->
        Logger.error("Cannot connect to infinibird_service!")
        %{}

      {:ok, response} ->
        Logger.info("fetched data from infinibird_service")

        data = Bson.decode(response.body)

        data
        |> Map.to_list()
        |> Enum.sort_by(fn ride ->
          data = ride |> elem(1)
          data.start_time
        end)
    end
  end
end

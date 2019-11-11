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

  @spec stream_rides(any) :: %{
          :__struct__ => HTTPoison.AsyncResponse | HTTPoison.Response,
          optional(:body) => any,
          optional(:headers) => [any],
          optional(:id) => reference,
          optional(:request) => HTTPoison.Request.t(),
          optional(:request_url) => any,
          optional(:status_code) => integer
        }
  def stream_rides(device_id) do
    [username: username, password: password, realm: _realm] =
      Application.get_env(:infinibird, :infinibird_service_basic_auth_config)

    credentials = "#{username}:#{password}" |> Base.encode64()

    HTTPoison.get!(
      "#{Application.get_env(:infinibird, :infinibird_service_url)}/infinibird/trips/#{device_id}",
      [{"Authorization", "Basic #{credentials}"}],
      stream_to: self(),
      async: :once,
      timeout: 50_000,
      recv_timeout: 50_000
    )
  end
end

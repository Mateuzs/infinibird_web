defmodule InfinibirdEngine.Api do
  alias InfinibirdEngine.Constants
  @infinibird_server Constants.infinibird_server()

  def get_mock_data(), do: GenServer.call(@infinibird_server, {:get_mock_data})
  def get_summary_data(), do: GenServer.call(@infinibird_server, {:get_summary_data})
  def get_trip_data(), do: GenServer.call(@infinibird_server, {:get_trip_data})
end

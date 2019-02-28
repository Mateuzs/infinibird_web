defmodule InfinibirdEngine.Api do
  alias InfinibirdEngine.Constants
  @infinibird_server Constants.infinibird_server()
  def get_mock_data(), do: GenServer.call(@infinibird_server, {:get_mock_data})
end

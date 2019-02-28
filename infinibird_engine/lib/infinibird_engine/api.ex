defmodule InfinibirdEngine.Api do
  @server_name :infinibird_server

  def get_mock_data(), do: GenServer.call(@server_name, {:get_mock_data})
end

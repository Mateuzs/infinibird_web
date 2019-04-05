defmodule InfinibirdEngine.Server do
  use GenServer
  alias InfinibirdEngine.{DataProvider, Constants}
  @infinibird_server Constants.infinibird_server()

  def start_link(state),
    do: GenServer.start_link(__MODULE__, state, name: @infinibird_server)

  def init(data), do: {:ok, data}

  def handle_call({:get_mock_data}, _from, state) do
    DataProvider.get_chart_mock_data()
    |> reply_success(:ok, state)
  end

  def handle_call({:get_summary_data}, _from, state) do
    data = DataProvider.get_summary_mock_data()
    bson = Bson.encode(data)
    IO.inspect(bson)
    reply_success(data, :ok, state)
  end

  defp reply_success(data, reply, state) do
    {:reply, {reply, data}, state}
  end
end

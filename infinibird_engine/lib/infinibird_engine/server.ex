defmodule InfinibirdEngine.Server do
  use GenServer
  alias InfinibirdEngine.{DataProvider, Constants}
  @infinibird_server Constants.infinibird_server()

  def start_link(state),
    do: GenServer.start_link(__MODULE__, state, name: @infinibird_server)

  def init(data), do: {:ok, data}

  ############### CALLBACKS  ###############

  def handle_call({:get_mock_data}, _from, state) do
    DataProvider.get_chart_mock_data()
    |> reply_success(:ok, state)
  end

  def handle_call({:get_summary_data}, _from, state) do
    File.read!(__DIR__ <> "/summary_data.bson")
    |> decode_bson_data()
    |> reply_success(:ok, state)
  end

  def handle_call({:get_trip_data}, _from, state) do
    File.read!(__DIR__ <> "/trip_data.bson")
    |> decode_bson_data()
    |> reply_success(:ok, state)
  end

  ############### HELPERS  ###############

  defp decode_bson_data(file) do
    case Bson.decode(file) do
      %Bson.Decoder.Error{} = error ->
        IO.puts(error)
        %{}

      %Bson.Decoder.Error{what: :buffer_not_empty, acc: _doc, rest: _rest} = error ->
        IO.puts(error)
        %{}

      decoded_data ->
        decoded_data
    end
  end

  defp reply_success(data, reply, state) do
    {:reply, {reply, data}, state}
  end
end

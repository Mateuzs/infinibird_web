defmodule InfinibirdWeb.ChartsController do
  use InfinibirdWeb, :controller

  @spec index(Plug.Conn.t(), any) :: Plug.Conn.t()
  def index(conn, _params) do
    device_id = Plug.Conn.get_session(conn, :current_device_id)

    charts =
      Infinibird.Cache.get(device_id, :charts)
      |> case do
        result when result === %{} ->
          %{}

        result ->
          result
      end

    render(conn, "index.html", charts: charts)
  end
end

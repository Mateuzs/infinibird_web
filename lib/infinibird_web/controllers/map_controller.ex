defmodule InfinibirdWeb.MapController do
  use InfinibirdWeb, :controller
  alias Phoenix.LiveView

  def index(conn, _params) do
    device_id = Plug.Conn.get_session(conn, :current_device_id)
    data = Infinibird.Cache.get(device_id, :trips) |> Bson.decode()

    LiveView.Controller.live_render(conn, InfinibirdWeb.TripView, session: %{data: data})
  end
end

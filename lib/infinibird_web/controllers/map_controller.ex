defmodule InfinibirdWeb.MapController do
  use InfinibirdWeb, :controller
  alias Phoenix.LiveView
  alias Infinibird.DataProvider

  def index(conn, _params) do
    device_id = Plug.Conn.get_session(conn, :current_device_id)
    trips = DataProvider.get_trips(device_id)

    LiveView.Controller.live_render(conn, InfinibirdWeb.TripView, session: %{data: trips})
  end
end

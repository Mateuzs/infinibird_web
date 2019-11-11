defmodule InfinibirdWeb.MapController do
  use InfinibirdWeb, :controller
  alias Phoenix.LiveView

  @spec index(Plug.Conn.t(), any) :: Plug.Conn.t()
  def index(conn, _params) do
    device_id = Plug.Conn.get_session(conn, :current_device_id)

    LiveView.Controller.live_render(conn, InfinibirdWeb.TripView, session: %{device_id: device_id})
  end
end

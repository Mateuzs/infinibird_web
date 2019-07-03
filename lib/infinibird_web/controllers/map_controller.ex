defmodule InfinibirdWeb.MapController do
  use InfinibirdWeb, :controller
  alias Phoenix.LiveView

  def index(conn, _params) do
    user_id = Plug.Conn.get_session(conn, :current_user_id)
    data = Infinibird.Cache.get(user_id, :trips) |> Bson.decode()

    IO.puts(conn.request_path)

    LiveView.Controller.live_render(conn, InfinibirdWeb.TripView, session: %{data: data})
  end
end

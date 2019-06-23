defmodule InfinibirdWeb.MapController do
  use InfinibirdWeb, :controller

  @spec index(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def index(conn, _params) do
    user_id = Plug.Conn.get_session(conn, :current_user_id)
    data = Infinibird.Cache.get(user_id, :trips) |> Bson.decode()

    render(conn, "index.html", trip_data: data)
  end
end

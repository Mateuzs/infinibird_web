defmodule InfinibirdWeb.MapController do
  use Phoenix.LiveView

  def render(assigns), do: InfinibirdWeb.MapView.render("index.html", assigns)

  def mount(session, socket) do
    user_id = session[:current_user_id]
    data = Infinibird.Cache.get(user_id, :trips) |> Bson.decode()

    {:ok,
     socket
     |> assign(:data, data)}
  end

  # def index(conn, _params) do
  #   user_id = Plug.Conn.get_session(conn, :current_user_id)
  #   data = Infinibird.Cache.get(user_id, :trips) |> Bson.decode()

  #   render(conn, "index.html", trip_data: data)
  # end
end

defmodule InfinibirdWeb.HomeController do
  use InfinibirdWeb, :controller

  def index(conn, _params) do
    device_id = Plug.Conn.get_session(conn, :current_device_id)


    summary = Infinibird.Cache.get(device_id, :summary)

    render(conn, "index.html",
      distance_meters: Map.get(summary, :distance_meters),
      number_of_trips: Map.get(summary, :number_of_trips),
      average_speed: Map.get(summary, :average_speed),
      max_speed: Map.get(summary, :max_speed),
      travel_time_minutes: Map.get(summary, :travel_time_minutes),
      longest_ride: Map.get(summary, :longest_ride)
    )
  end
end

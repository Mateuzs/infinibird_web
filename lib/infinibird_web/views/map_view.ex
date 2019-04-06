defmodule InfinibirdWeb.MapView do
  use InfinibirdWeb, :view

  def get_trip_data(conn) do
    conn.assigns[:trip_data]
  end

  def trips(conn) do
    ["Trasa 1"]
  end
end

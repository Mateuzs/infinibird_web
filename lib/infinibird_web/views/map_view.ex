defmodule InfinibirdWeb.MapView do
  use InfinibirdWeb, :view

  def trips(conn) do
    data = conn.assigns[:trip_data]
  end
end

defmodule InfinibirdWeb.MapView do
  use InfinibirdWeb, :view

  def get_trip_data(conn, key) do
    Map.get(conn.assigns[:trip_data], key)
    |> Map.get(:points)
    |> Jason.encode!()
  end

  def trips(conn) do
    Map.keys(conn.assigns[:trip_data])
    |> Enum.map(fn key ->
      name = Map.get(conn.assigns[:trip_data], key) |> Map.get(:name)
      {key, name}
    end)
  end
end

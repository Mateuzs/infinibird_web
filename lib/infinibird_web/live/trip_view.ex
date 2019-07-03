defmodule InfinibirdWeb.TripView do
  use Phoenix.LiveView

  def render(assigns), do: InfinibirdWeb.MapView.render("index.html", assigns)

  def mount(session, socket) do
    trips = Map.get(session, :data)

    {:ok, socket |> assign(trasa: "Ready!") |> assign(trips: trips)}
  end

  def trips(conn) do
    conn.assigns[:trip_data]
  end

  def foo(conn) do
    IO.inspect(conn.assigns[:trip_data])
  end
end

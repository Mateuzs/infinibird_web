defmodule InfinibirdWeb.TripView do
  use Phoenix.LiveView

  def render(assigns) do
    InfinibirdWeb.MapView.render("index.html", assigns)
  end

  def mount(session, socket) do
    trips = Map.get(session, :data)

    {:ok,
     socket
     |> assign(distance: "")
     |> assign(travel_time: "")
     |> assign(time_start: "")
     |> assign(time_end: "")
     |> assign(trips: trips)}
  end

  def handle_event("get-user-data", value, socket) do
    trips = socket.assigns.trips
    trip = String.to_atom(value)
    trips[trip]

    distance = trips[trip].distance_meters

    distance_string =
      case Kernel.trunc(distance / 1000) do
        0 -> "#{distance}m"
        kilometers -> "#{kilometers}km #{rem(distance, 1000)}m"
      end

    travel_time_minutes = trips[trip].travel_time_minutes

    travel_time_string =
      case Kernel.trunc(travel_time_minutes / 60) do
        0 -> "#{travel_time_minutes}min"
        hours -> "#{hours}h #{rem(travel_time_minutes, 60)}min"
      end

    {:noreply,
     socket
     |> assign(distance: distance_string)
     |> assign(travel_time: travel_time_string)
     |> assign(time_start: trips[trip].start_time)
     |> assign(time_end: trips[trip].end_time)}
  end
end

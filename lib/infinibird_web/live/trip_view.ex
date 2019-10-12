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
     |> assign(average_speed: "")
     |> assign(max_speed: "")
     |> assign(time_start: "")
     |> assign(time_end: "")
     |> assign(acc_amount: "")
     |> assign(dec_amount: "")
     |> assign(stp_amount: "")
     |> assign(lt_amount: "")
     |> assign(rt_amount: "")
     |> assign(trips: Map.to_list(trips))}
  end

  def handle_event("get-user-data", value, socket) do
    trips = socket.assigns.trips
    trip = String.to_atom(value)

    distance = trips[trip].distance_meters

    distance_string =
      case Kernel.trunc(distance / 1000) do
        0 -> "#{distance} m"
        kilometers -> "#{kilometers} km #{rem(distance, 1000)} m"
      end

    travel_time_minutes = trips[trip].travel_time_minutes

    travel_time_string =
      case Kernel.trunc(travel_time_minutes / 60) do
        0 -> "#{travel_time_minutes} min"
        hours -> "#{hours} h #{rem(travel_time_minutes, 60)} min"
      end

    speed_km_h =
      case travel_time_minutes do
        0 -> 0
        _more_than_0 -> (distance / 1000 / (travel_time_minutes / 60)) |> Kernel.trunc()
      end

    average_speed_string = "#{speed_km_h} km/h"

    max_speed = "#{Kernel.trunc(trips[trip].max_speed * 3.6)} km/h"

    {:noreply,
     socket
     |> assign(distance: distance_string)
     |> assign(travel_time: travel_time_string)
     |> assign(average_speed: average_speed_string)
     |> assign(max_speed: max_speed)
     |> assign(time_start: trips[trip].start_time)
     |> assign(time_end: trips[trip].end_time)
     |> assign(acc_amount: trips[trip].acceleration_amount)
     |> assign(dec_amount: trips[trip].deceleration_amount)
     |> assign(stp_amount: trips[trip].stoppings_amount)
     |> assign(lt_amount: trips[trip].left_turns_amount)
     |> assign(rt_amount: trips[trip].right_turns_amount)}
  end
end

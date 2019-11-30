defmodule InfinibirdWeb.TripView do
  use Phoenix.LiveView
  alias Infinibird.DataProvider

  def render(assigns) do
    InfinibirdWeb.MapView.render("index.html", assigns)
  end

  def mount(session, socket) do
    device_id = Map.get(session, :device_id)

    if connected?(socket) do
      send(self(), {:get_trips, device_id})
    end

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
     |> assign(trips: [])}
  end

  def handle_info({:get_trips, device_id}, socket) do
    # async rides fetching - chunks, TODO: fix problem on Gigalixir
    # rides_stream_ref = DataProvider.stream_rides(device_id)
    # {:noreply, socket |> assign(rides_stream_ref: rides_stream_ref)}

    {:ok, %HTTPoison.Response{body: trips}} = DataProvider.fetch_trips(device_id)

    decoded_trips = Bson.decode(trips)

    {:noreply,
     assign(socket,
       trips:
         Enum.sort_by(decoded_trips, fn e ->
           elem(e, 1).start_time
         end)
     )}
  end

  def handle_info(async_response, socket) do
    rides_stream_ref = socket.assigns.rides_stream_ref
    rides_stream_ref_id = rides_stream_ref.id

    case async_response do
      %HTTPoison.AsyncStatus{id: ^rides_stream_ref_id} ->
        HTTPoison.stream_next(rides_stream_ref)
        {:noreply, socket}

      %HTTPoison.AsyncHeaders{id: ^rides_stream_ref_id} ->
        HTTPoison.stream_next(rides_stream_ref)
        {:noreply, socket}

      %HTTPoison.AsyncChunk{chunk: chunk, id: ^rides_stream_ref_id} when chunk !== "Not found!" ->
        HTTPoison.stream_next(rides_stream_ref)

        decoded_trips = Bson.decode(chunk)

        old_trips = socket.assigns.trips
        new_trips = decoded_trips |> Map.to_list()

        {:noreply,
         assign(socket,
           trips:
             Enum.sort_by(old_trips ++ new_trips, fn e ->
               elem(e, 1).start_time
             end)
         )}

      %HTTPoison.AsyncChunk{chunk: _chunk, id: ^rides_stream_ref_id} ->
        HTTPoison.stream_next(rides_stream_ref)
        {:noreply, socket}

      %HTTPoison.AsyncEnd{id: ^rides_stream_ref_id} ->
        {:noreply, socket}
    end
  end

  @spec handle_event(<<_::104>>, any, Phoenix.LiveView.Socket.t()) :: {:noreply, any}
  def handle_event("get-trip-data", trip_id, socket) do
    trips = socket.assigns.trips
    trip = String.to_atom(trip_id)

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

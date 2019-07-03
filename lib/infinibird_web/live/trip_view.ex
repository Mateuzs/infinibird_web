defmodule InfinibirdWeb.TripView do
  use Phoenix.LiveView

  def render(assigns) do
    InfinibirdWeb.MapView.render("index.html", assigns)
  end

  def mount(session, socket) do
    trips = Map.get(session, :data)

    {:ok, socket |> assign(trasa: "Ready!") |> assign(trips: trips)}
  end

  def handle_event("get-user-data", _value, socket) do
    # do the deploy process
    IO.puts("fasdfasdfdsa")
    {:noreply, assign(socket, trasa: "changed!")}
  end
end

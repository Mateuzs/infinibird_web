defmodule InfinibirdWeb.MapView do
  use InfinibirdWeb, :view
  import Phoenix.LiveView

  def trips(conn) do
    conn.assigns[:trip_data]
  end

  def foo(conn) do
    IO.inspect(conn.assigns[:trip_data])

    "hello"
  end
end

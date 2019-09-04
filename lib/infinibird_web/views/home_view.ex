defmodule InfinibirdWeb.HomeView do
  use InfinibirdWeb, :view

  def amount_of_km(conn) do
    conn.assigns[:amount_of_km]
  end

  def number_of_trips(conn) do
    conn.assigns[:number_of_trips]
  end

  def average_speed(conn) do
    conn.assigns[:average_speed]
  end

  def max_speed(conn) do
    conn.assigns[:max_speed]
  end

  def longest_ride(conn) do
    conn.assigns[:longest_ride]
  end

  def safety_index(conn) do
    conn.assigns[:safety_index] |> String.trim("\"")
  end
end

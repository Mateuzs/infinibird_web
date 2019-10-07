defmodule InfinibirdWeb.HomeView do
  use InfinibirdWeb, :view

  def distance(conn) do
    case conn.assigns[:distance_meters] do
      nil -> nil
      distance when distance < 1000 -> "#{distance}m"
      distance -> "#{Kernel.trunc(distance / 1000)}km #{rem(distance, 1000)}m"
    end
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

  def max_acceleration(conn) do
    conn.assigns[:max_acceleration]
  end

  def longest_ride(conn) do
    case conn.assigns[:longest_ride] do
      nil -> nil
      distance when distance < 1000 -> "#{distance}m"
      distance -> "#{Kernel.trunc(distance / 1000)}km #{rem(distance, 1000)}m"
    end
  end

  def travel_time(conn) do
    case conn.assigns[:travel_time_minutes] do
      nil -> nil
      time when time < 60 -> "#{time}min"
      time -> "#{Kernel.trunc(time / 60)}hrs #{rem(time, 60)}min"
    end
  end

  def most_famous_day(conn) do
    case conn.assigns[:most_famous_day] do
      nil -> nil
      "monday" -> "poniedziałek"
      "tuesday" -> "wtorek"
      "wednesday" -> "środa"
      "thursday" -> "czwartek"
      "friday" -> "piątek"
      "saturday" -> "sobota"
      "sunday" -> "niedziela"
    end
  end

  def most_famous_time_of_day(conn) do
    case conn.assigns[:most_famous_time_of_day] do
      nil -> nil
      "night" -> "noc"
      "morning" -> "poranek"
      "midday" -> "południe"
      "afternoon" -> "popołudnie"
      "evening" -> "wieczór"
    end
  end
end

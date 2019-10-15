defmodule InfinibirdWeb.HomeView do
  use InfinibirdWeb, :view

  @spec distance(atom | %{assigns: nil | keyword | map}) :: nil | String.t()
  def distance(conn) do
    case conn.assigns[:distance_meters] do
      nil -> nil
      distance when distance < 1000 -> "#{distance}m"
      distance -> "#{Kernel.trunc(distance / 1000)}km #{rem(distance, 1000)}m"
    end
  end

  @spec number_of_trips(atom | %{assigns: nil | keyword | map}) :: String.t()
  def number_of_trips(conn) do
    conn.assigns[:number_of_trips]
  end

  @spec average_speed(atom | %{assigns: nil | keyword | map}) :: String.t()
  def average_speed(conn) do
    conn.assigns[:average_speed]
  end

  @spec max_speed(atom | %{assigns: nil | keyword | map}) :: String.t()
  def max_speed(conn) do
    conn.assigns[:max_speed]
  end

  @spec max_acceleration(atom | %{assigns: nil | keyword | map}) :: String.t()
  def max_acceleration(conn) do
    conn.assigns[:max_acceleration]
  end

  @spec longest_ride(atom | %{assigns: nil | keyword | map}) :: nil | String.t()
  def longest_ride(conn) do
    case conn.assigns[:longest_ride] do
      nil -> nil
      distance when distance < 1000 -> "#{distance}m"
      distance -> "#{Kernel.trunc(distance / 1000)}km #{rem(distance, 1000)}m"
    end
  end

  @spec travel_time(atom | %{assigns: nil | keyword | map}) :: nil | String.t()
  def travel_time(conn) do
    case conn.assigns[:travel_time_minutes] do
      nil -> nil
      time when time < 60 -> "#{time}min"
      time -> "#{Kernel.trunc(time / 60)}hrs #{rem(time, 60)}min"
    end
  end

  @spec most_famous_day(atom | %{assigns: nil | keyword | map}) :: nil | String.t()
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

  @spec most_famous_time_of_day(atom | %{assigns: nil | keyword | map}) :: nil | String.t()
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

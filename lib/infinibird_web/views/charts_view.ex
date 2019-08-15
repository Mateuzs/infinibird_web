defmodule InfinibirdWeb.ChartsView do
  use InfinibirdWeb, :view

  def get_speed_profile_chart_data(conn) do
    case conn.assigns[:speed_profile_chart_data] do
      nil -> []
      data -> data
    end
  end

  def get_km_7days_chart_data(conn) do
    case conn.assigns[:km_7days_chart_data] do
      nil -> []
      data -> data
    end
  end

  def get_rides_amount_7days_chart_data(conn) do
    case conn.assigns[:rides_amount_7days_chart_data] do
      nil -> []
      data -> data
    end
  end

  def get_time_in_car_7days_chart_data(conn) do
    case conn.assigns[:time_in_car_7days_chart_data] do
      nil -> []
      data -> data
    end
  end

  def get_km_3months_chart_data(conn) do
    case conn.assigns[:km_3months_chart_data] do
      nil -> []
      data -> data
    end
  end

  def get_acc_dec_chart_data(conn) do
    case conn.assigns[:acc_dec_chart_data] do
      nil -> []
      data -> data
    end
  end

  def get_turns_chart_data(conn) do
    case conn.assigns[:turns_chart_data] do
      nil -> []
      data -> data
    end
  end
end

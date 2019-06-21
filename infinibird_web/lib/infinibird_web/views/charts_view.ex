defmodule InfinibirdWeb.ChartsView do
  use InfinibirdWeb, :view

  def pie_chart_data(conn) do
    case conn.assigns[:pie_chart_data] do
      nil -> []
      pie_chart_data -> pie_chart_data
    end
  end

  def line_chart_data(conn) do
    case conn.assigns[:line_chart_data] do
      nil -> []
      line_chart_data -> line_chart_data
    end
  end

  def column_chart_data(conn) do
    case conn.assigns[:column_chart_data] do
      nil -> []
      column_chart_data -> column_chart_data
    end
  end

  def area_chart_data(conn) do
    case conn.assigns[:area_chart_data] do
      nil -> []
      area_chart_data -> area_chart_data
    end
  end

  def geo_chart_data(conn) do
    case conn.assigns[:geo_chart_data] do
      nil -> []
      geo_chart_data -> geo_chart_data
    end
  end

  def multilines_chart_data(conn) do
    case conn.assigns[:multilines_chart_data] do
      nil -> []
      multilines_chart_data -> multilines_chart_data
    end
  end
end

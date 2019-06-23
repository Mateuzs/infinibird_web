defmodule InfinibirdWeb.ChartsController do
  use InfinibirdWeb, :controller

  def index(conn, _params) do
    user_id = Plug.Conn.get_session(conn, :current_user_id)
    %{charts: charts, summary: _summary} = Infinibird.Cache.get(user_id, :summary) |> Bson.decode()

    render(conn, "index.html",
      pie_chart_data: Jason.encode!(Map.get(charts, :pie_chart_data)),
      line_chart_data: Jason.encode!(Map.get(charts, :line_chart_data)),
      column_chart_data: Jason.encode!(Map.get(charts, :column_chart_data)),
      area_chart_data: Jason.encode!(Map.get(charts, :area_chart_data)),
      geo_chart_data: Jason.encode!(Map.get(charts, :geo_chart_data)),
      multilines_chart_data: Jason.encode!(Map.get(charts, :multilines_chart_data))
    )
  end
end

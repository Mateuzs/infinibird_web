defmodule InfinibirdWeb.ChartsController do
  use InfinibirdWeb, :controller
  alias InfinibirdService.Api

  def index(conn, _params) do
    {:ok, data} = Api.get_mock_data()

    render(conn, "index.html",
      pie_chart_data: Jason.encode!(Map.get(data, :pie_chart_data)),
      line_chart_data: Jason.encode!(Map.get(data, :line_chart_data)),
      column_chart_data: Jason.encode!(Map.get(data, :column_chart_data)),
      area_chart_data: Jason.encode!(Map.get(data, :area_chart_data)),
      geo_chart_data: Jason.encode!(Map.get(data, :geo_chart_data)),
      multilines_chart_data: Jason.encode!(Map.get(data, :multilines_chart_data))
    )
  end
end

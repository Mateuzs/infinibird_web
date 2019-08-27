defmodule InfinibirdWeb.ChartsController do
  use InfinibirdWeb, :controller

  def index(conn, _params) do
    user_id = Plug.Conn.get_session(conn, :current_user_id)

    %{charts: charts, summary: _summary} =
      Infinibird.Cache.get(user_id, :summary)
      |> case do
        %{} -> %{charts: %{}, summary: %{}}
        result -> Bson.decode(result)
      end

    render(conn, "index.html",
      speed_profile_chart_data: Jason.encode!(Map.get(charts, :speed_profile_chart_data)),
      km_7days_chart_data: Jason.encode!(Map.get(charts, :km_7days_chart_data)),
      rides_amount_7days_chart_data:
        Jason.encode!(Map.get(charts, :rides_amount_7days_chart_data)),
      time_in_car_7days_chart_data: Jason.encode!(Map.get(charts, :time_in_car_7days_chart_data)),
      km_3months_chart_data: Jason.encode!(Map.get(charts, :km_3months_chart_data)),
      acc_dec_chart_data: Jason.encode!(Map.get(charts, :acc_dec_chart_data)),
      turns_chart_data: Jason.encode!(Map.get(charts, :turns_chart_data))
    )
  end
end

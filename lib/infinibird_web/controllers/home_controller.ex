defmodule InfinibirdWeb.HomeController do
  use InfinibirdWeb, :controller

  def index(conn, _params) do
    user_id = Plug.Conn.get_session(conn, :current_user_id)

    %{charts: _charts, summary: summary} =
      Infinibird.Cache.get(user_id, :summary)
      |> case do
        %{} -> %{charts: %{}, summary: %{}}
        result -> Bson.decode(result)
      end

    render(conn, "index.html",
      amount_of_km: Jason.encode!(Map.get(summary, :amount_of_km)),
      number_of_trips: Jason.encode!(Map.get(summary, :number_of_trips)),
      average_speed: Jason.encode!(Map.get(summary, :average_speed)),
      safety_index: Jason.encode!(Map.get(summary, :safety_index))
    )
  end
end

defmodule InfinibirdWeb.HomeController do
  use InfinibirdWeb, :controller
  alias InfinibirdService.Api

  def index(conn, _params) do
    {:ok, data} = Api.get_summary_data()

    render(conn, "index.html",
      amount_of_km: Jason.encode!(Map.get(data, :amount_of_km)),
      number_of_trips: Jason.encode!(Map.get(data, :number_of_trips)),
      average_speed: Jason.encode!(Map.get(data, :average_speed)),
      safety_index: Jason.encode!(Map.get(data, :safety_index))
    )
  end
end

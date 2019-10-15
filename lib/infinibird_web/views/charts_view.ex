defmodule InfinibirdWeb.ChartsView do
  use InfinibirdWeb, :view

  @spec get_charts_data(atom | %{assigns: nil | keyword | map}) :: any
  def get_charts_data(conn) do
    case conn.assigns[:charts] do
      charts when charts == [] -> nil
      charts -> charts
    end
  end
end

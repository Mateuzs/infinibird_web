defmodule InfinibirdWeb.PageController do
  use InfinibirdWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end

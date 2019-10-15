defmodule InfinibirdWeb.Plugs.AuthenticateUser do
  import Plug.Conn
  import Phoenix.Controller

  @spec init(any) :: nil
  def init(_params) do
  end

  def call(conn, _params) do
    if conn.assigns.user_signed_in? do
      conn
    else
      conn
      |> redirect(to: "/login")
      |> halt()
    end
  end
end

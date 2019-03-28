defmodule InfinibirdWeb.Plugs.SetCurrentUser do
  import Plug.Conn

  def init(_params) do
  end

  def call(conn, _params) do
    current_user = Plug.Conn.get_session(conn, :current_user_token)

    case current_user do
      nil ->
        conn
        |> assign(:current_user, nil)
        |> assign(:user_signed_in?, false)

      _ ->
        conn
        |> assign(:current_user, current_user)
        |> assign(:user_signed_in?, true)
    end
  end
end

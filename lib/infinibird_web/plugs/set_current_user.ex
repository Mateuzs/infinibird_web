defmodule InfinibirdWeb.Plugs.SetCurrentUser do
  import Plug.Conn

  @spec init(any) :: nil
  def init(_params) do
  end

  @spec call(Plug.Conn.t(), any) :: Plug.Conn.t()
  def call(conn, _params) do
    current_user = Plug.Conn.get_session(conn, :current_user_id)

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

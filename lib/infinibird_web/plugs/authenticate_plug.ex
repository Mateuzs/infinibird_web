defmodule InfinibirdWeb.Plugs.Authenticate do
  use InfinibirdWeb, :controller
  import Plug.Conn

  def init(default), do: default

  def call(conn, _default) do
    case Infinibird.Auth.AuthService.get_auth_token(conn) do
      {:ok, _token} ->
        authorized(conn)

      _ ->
        unauthorized(conn)
    end
  end

  defp authorized(conn) do
    # If you want, add new values to `conn`
    conn
    |> assign(:signed_in, true)
  end

  defp unauthorized(conn) do
    redirect(conn, to: "/login") |> halt
  end
end

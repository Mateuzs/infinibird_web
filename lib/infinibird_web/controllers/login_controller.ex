defmodule InfinibirdWeb.LoginController do
  use InfinibirdWeb, :controller
  alias Infinibird.Auth.User

  @spec index(Plug.Conn.t(), any) :: Plug.Conn.t()
  def index(conn, _params) do
    case User.authenticate_user(conn) do
      true ->
        redirect(conn, to: "/")

      false ->
        logged_in = User.authenticate_user(conn)
        render(conn, "index.html", logged_in: logged_in)
    end
  end

  def create(conn, credentials) do
    case User.sign_in(Map.get(credentials, "key")) do
      {:ok, user_id, device_id} ->
        conn
        |> put_session(:current_user_id, user_id)
        |> put_session(:current_device_id, device_id)
        |> redirect(to: "/")

      {:error, _error} ->
        conn
        |> put_flash(:error, "Nieprawidłowy token!")
        |> redirect(to: "/login")
    end
  end

  def delete(conn, _params) do
    User.sign_out(conn)
    |> redirect(to: "/")
  end
end

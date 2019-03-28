defmodule InfinibirdWeb.LoginController do
  use InfinibirdWeb, :controller
  alias Infinibird.Auth.User

  def index(conn, _params) do
    logged_in = User.authenticate_user(conn)
    render(conn, "index.html", logged_in: logged_in)
  end

  def create(conn, credentials) do
    case User.sign_in(Map.get(credentials, "key")) do
      {:ok, token} ->
        conn
        |> put_session(:current_user_token, token)
        |> put_flash(:info, "You have successfully signed in!")
        |> redirect(to: "/login")

      {:error, _error} ->
        conn
        |> put_flash(:error, "User key is incorrect")
        |> redirect(to: "/login")
    end
  end

  def delete(conn, _params) do
    User.sign_out(conn)
    |> redirect(to: "/")
  end
end

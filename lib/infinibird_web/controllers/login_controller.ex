defmodule InfinibirdWeb.LoginController do
  use InfinibirdWeb, :controller
  alias Infinibird.Auth.{AuthService, User}

  def index(conn, _params) do
    {_status, token} = AuthService.get_auth_token(conn)
    changeset = User.changeset(%User{})
    render(conn, "index.html", changeset: changeset, token: token)
  end

  def login(conn, %{"user" => %{"key" => key}}) do
    User.sign_in(key)
    |> login_reply(conn)
  end

  defp login_reply({:error, _error}, conn) do
    conn
    |> put_flash(:error, "User key is incorrect")
    |> redirect(to: "/login")
  end

  defp login_reply({:ok, token}, conn) do
    redirect(conn, to: "/login", message: token)
  end

  def logout(conn, _) do
    User.sign_out(conn)
    |> assign(:signed_in, true)
    |> assign(:auth, nil)
    |> redirect(to: "/login")
  end
end

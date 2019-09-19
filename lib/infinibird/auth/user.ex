defmodule Infinibird.Auth.User do
  require Logger
  alias Infinibird.Auth.AuthService

  def sign_in(key) do
    case AuthService.authorise(key) do
      {:authorised, user_id, device_id} ->
        {:ok, user_id, device_id}

      {:unauthorised} ->
        {:error, :wrong_key}
    end
  end

  @spec authenticate_user(Plug.Conn.t()) :: boolean
  def authenticate_user(conn) do
    current_user_token = Plug.Conn.get_session(conn, :current_user_id)

    !!current_user_token
  end

  @spec sign_out(Plug.Conn.t()) :: Plug.Conn.t()
  def sign_out(conn) do
    Infinibird.Cache.delete(Plug.Conn.get_session(conn, :current_device_id))
    Logger.info("Deleted cached user data")

    Plug.Conn.configure_session(conn, drop: true)
  end
end

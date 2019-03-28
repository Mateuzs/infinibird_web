defmodule Infinibird.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset

  # alias Comeonin.Bcrypt
  alias Infinibird.Auth.AuthService

  schema "users" do
    field :email, :string
    field :encrypted_password, :string
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs \\ %{}) do
    user
    |> cast(attrs, [:email, :username, :encrypted_password])
    |> validate_required([:email, :username, :encrypted_password])
    |> unique_constraint(:email)
    |> unique_constraint(:username)
  end

  @spec sign_in(any()) :: any()
  def sign_in(key) do
    case AuthService.authorise(key) do
      :authorised ->
        token = AuthService.generate_token(key)
        {:ok, token}

      :unauthorised ->
        {:error, :wrong_key}
    end
  end

  def authenticate_user(conn) do
    current_user_token = Plug.Conn.get_session(conn, :current_user_token)

    !!current_user_token
  end

  def sign_out(conn) do
    Plug.Conn.configure_session(conn, drop: true)
  end
end

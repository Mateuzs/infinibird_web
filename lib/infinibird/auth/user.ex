defmodule Infinibird.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset

  # alias Comeonin.Bcrypt
  alias Infinibird.Auth.AuthService

  @secret_key "12345678"

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
    case key do
      @secret_key ->
        token = AuthService.generate_token(key)
        {:ok, token}

      _ ->
        {:error, :wrong_key}
    end
  end

  def sign_out(conn) do
    case AuthService.get_auth_token(conn) do
      {:ok, token} ->
        case conn.assigns[:auth] do
          current_token when current_token === token ->
            conn

          error ->
            error
        end

      error ->
        error
    end
  end
end

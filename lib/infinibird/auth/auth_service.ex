defmodule Infinibird.Auth.AuthService do
  require Logger

  def authorise(user_password) do
    [username: username, password: password, realm: _realm] =
      Application.get_env(:infinibird, :infinibird_service_basic_auth_config)

    credentials = "#{username}:#{password}" |> Base.encode64()

    [argon_salt: argon_salt] = Application.get_env(:infinibird, :argon)

    hashed_password = Argon2.Base.hash_password(user_password, argon_salt, format: :raw_hash)

    Logger.info("authorising user in infinibird_service")

    HTTPoison.post(
      "#{Application.get_env(:infinibird, :infinibird_service_url)}/infinibird/authorise",
      Jason.encode!(%{password: hashed_password}),
      [{"Content-type", "application/json"}, {"Authorization", "Basic #{credentials}"}]
    )
    |> case do
      {:error, _error} ->
        Logger.error("Cannot connect to infinibird_service!")
        {:unauthorised}

      {:ok, response} ->
        Logger.info("get response from infinibird_service")

        res = Jason.decode!(response.body)

        case res["authorised"] do
          true -> {:authorised, hashed_password, res["device_id"]}
          false -> {:unauthorised}
        end
    end
  end

  @spec generate_token(any()) :: any()
  def generate_token(id) do
    token_gen_data = Application.get_env(:phoenix, :phoenix_token_data)

    Phoenix.Token.sign(token_gen_data.secret, token_gen_data.salt, id, max_age: 86400)
  end

  @spec verify_token(nil | binary()) ::
          {:error, :expired | :invalid | :missing} | {:ok, nil | binary()}
  def verify_token(token) do
    token_gen_data = Application.get_env(:phoenix, :phoenix_token_data)

    case Phoenix.Token.verify(token_gen_data.secret, token_gen_data.salt, token, max_age: 86400) do
      {:ok, _id} -> {:ok, token}
      error -> error
    end
  end

  def get_auth_token(conn) do
    case extract_token(conn) do
      {:ok, token} ->
        verify_token(token)

      error ->
        error
    end
  end

  defp extract_token(conn) do
    case conn.assigns do
      map when map === %{} ->
        {:error, nil}

      map ->
        case map.auth do
          nil ->
            {:error, nil}

          token ->
            {:ok, token}
        end
    end
  end
end

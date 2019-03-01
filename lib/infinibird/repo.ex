defmodule Infinibird.Repo do
  use Ecto.Repo,
    otp_app: :infinibird,
    adapter: Ecto.Adapters.Postgres
end

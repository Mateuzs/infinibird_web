defmodule InfinibirdInterface.Repo do
  use Ecto.Repo,
    otp_app: :infinibird_interface,
    adapter: Ecto.Adapters.Postgres
end

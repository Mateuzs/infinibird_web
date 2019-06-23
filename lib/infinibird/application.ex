defmodule Infinibird.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      Infinibird.Repo,
      # Start the endpoint when the application starts
      InfinibirdWeb.Endpoint
      # Starts a worker by calling: Infinibird.Worker.start_link(arg)
      # {Infinibird.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    # this is mock for auth user for now, till the database and proper sytem will be delivered
    :ets.new(:infinibird_cache, [:public, :named_table])
    opts = [strategy: :one_for_one, name: Infinibird.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    InfinibirdWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

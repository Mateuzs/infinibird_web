defmodule Infinibird.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @spec start(any, any) :: {:error, any} | {:ok, pid}
  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the endpoint when the application starts
      InfinibirdWeb.Endpoint
    ]

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

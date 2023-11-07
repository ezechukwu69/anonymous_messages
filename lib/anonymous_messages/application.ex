defmodule AnonymousMessages.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      AnonymousMessagesWeb.Telemetry,
      AnonymousMessages.Repo,
      {DNSCluster, query: Application.get_env(:anonymous_messages, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: AnonymousMessages.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: AnonymousMessages.Finch},
      # Start a worker by calling: AnonymousMessages.Worker.start_link(arg)
      # {AnonymousMessages.Worker, arg},
      # Start to serve requests, typically the last entry
      AnonymousMessagesWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AnonymousMessages.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AnonymousMessagesWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

defmodule EventPlanning.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      EventPlanning.Repo,
      EventPlanningWeb.Telemetry,
      {Phoenix.PubSub, name: EventPlanning.PubSub},
      EventPlanningWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: EventPlanning.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    EventPlanningWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

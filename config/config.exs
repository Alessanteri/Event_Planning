use Mix.Config

config :event_planning,
  ecto_repos: [EventPlanning.Repo]

config :event_planning, EventPlanningWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "2IiRmWy8PC61P0Xjns/xrG0TEKt25h2+9THQqByvY8yjJEmS/q2T7BPCj/XQD+JT",
  render_errors: [view: EventPlanningWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: EventPlanning.PubSub,
  live_view: [signing_salt: "HB/zpGiy"]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

import_config "#{Mix.env()}.exs"

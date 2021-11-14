use Mix.Config

# Configure your database
config :event_planning, EventPlanning.Repo,
  username: "postgres",
  password: "123456789",
  database: "event_planning_repo",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :event_planning, EventPlanningWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [
    node: [
      "node_modules/webpack/bin/webpack.js",
      "--mode",
      "development",
      "--watch-stdin",
      cd: Path.expand("../assets", __DIR__)
    ]
  ]

config :event_planning, EventPlanningWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/event_planning_web/(live|views)/.*(ex)$",
      ~r"lib/event_planning_web/templates/.*(eex)$"
    ]
  ]

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :phoenix, :plug_init_mode, :runtime

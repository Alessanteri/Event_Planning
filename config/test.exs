use Mix.Config

config :event_planning, EventPlanning.Repo,
  username: "postgres",
  password: "123456789",
  database: "event_planning_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :event_planning, EventPlanningWeb.Endpoint,
  http: [port: 4002],
  server: false

config :logger, level: :warn

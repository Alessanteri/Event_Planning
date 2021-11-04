defmodule EventPlanningWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :event_planning

  @session_options [
    store: :cookie,
    key: "_hello_phoenix_key",
    signing_salt: "t93o9LJ5"
  ]

  socket("/socket", EventPlanningWeb.UserSocket,
    websocket: true,
    longpoll: false
  )

  socket("/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session_options]])

  plug(Plug.Static,
    at: "/",
    from: :event_planning,
    gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)
  )

  if code_reloading? do
    socket("/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket)
    plug(Phoenix.LiveReloader)
    plug(Phoenix.CodeReloader)
    plug(Phoenix.Ecto.CheckRepoStatus, otp_app: :event_planning)
  end

  plug(Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"
  )

  plug(Plug.RequestId)
  plug(Plug.Telemetry, event_prefix: [:phoenix, :endpoint])

  plug(Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()
  )

  plug(Plug.MethodOverride)
  plug(Plug.Head)

  plug(Plug.Session,
    store: :cookie,
    secure: false,
    key: "_hello_phoenix_key",
    table: :session,
    signing_salt: "_hello_phoenix_key",
    key_length: 64
  )

  plug(EventPlanningWeb.Router)
end

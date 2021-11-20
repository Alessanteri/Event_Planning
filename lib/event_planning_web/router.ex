defmodule EventPlanningWeb.Router do
  use EventPlanningWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", EventPlanningWeb do
    pipe_through(:browser)

    get("/", PageController, :login)
    post("/", PageController, :login)
  end

  scope "/", EventPlanningWeb do
    pipe_through(:browser)

    resources("/users", UserController) do
      resources("/event", EventController, except: [:index])
      get("/my_schedule", EventController, :my_schedule)
      post("/my_schedule", EventController, :my_schedule)
      get("/next_event", EventController, :next_event)
    end

    resources("/session", SessionController,
      only: [:new, :create, :delete]
      # singleton: true
    )
  end

  scope "/", EventPlanningWeb do
    pipe_through([:browser, :authenticate_user])

    get("/home", HomeController, :index)
  end

  # scope "/iae"  Ev

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through(:browser)
      live_dashboard("/dashboard", metrics: EventPlanningWeb.Telemetry)
    end
  end

  defp authenticate_user(conn, _) do
    case get_session(conn, :user_id) do
      nil ->
        conn
        |> Phoenix.Controller.put_flash(:error, "Login required")
        |> Phoenix.Controller.redirect(to: "/session/new")
        |> halt()

      user_id ->
        assign(conn, :current_user, EventPlanning.Accounts.get_user!(user_id))
    end
  end
end

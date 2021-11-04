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
    get("/home", HomeController, :index)
  end

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through(:browser)
      live_dashboard("/dashboard", metrics: EventPlanningWeb.Telemetry)
    end
  end
end

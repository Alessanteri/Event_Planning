defmodule EventPlanningWeb.Router do
  use EventPlanningWeb, :router

  alias EventPlanning.Models.User
  alias EventPlanning.Repo

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

    resources("/", PageController, only: [:new, :create, :delete])
  end

  scope "/", EventPlanningWeb do
    pipe_through(:browser)

    resources("/users", UserController) do
      resources("/event", EventController, except: [:index])
      get("/my_schedule", EventController, :my_schedule)
      post("/my_schedule", EventController, :my_schedule)
      get("/next_event", EventController, :next_event)
    end
  end

  scope "/", EventPlanningWeb do
    pipe_through([:browser])

    get("/home", HomeController, :index)
  end

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
        |> redirect(to: Routes.page_path(conn, :new))
        |> halt()

      user_id ->
        assign(conn, :current_user, Repo.get!(User, user_id))
    end
  end
end

# no match of right hand side value: %{"_csrf_token" => "PgBRCklHAxQxHj5UPSITfQkFMQgHKToMlX0A36PDenreywI09NHPJcPm", "page" => %{"categories_id" => "year"}}

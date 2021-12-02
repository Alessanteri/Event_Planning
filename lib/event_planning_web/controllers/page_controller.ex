defmodule EventPlanningWeb.PageController do
  use EventPlanningWeb, :controller

  alias EventPlanning.Operation.User.Workflow

  @password "DgB4PPljWY"

  def new(conn, _params) do
    if get_session(conn, :password) == @password do
      redirect(conn,
        to: Routes.user_event_path(conn, :my_schedule, get_session(conn, :current_user).id)
      )
    else
      render(conn, "new.html")
    end
  end

  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    case Workflow.authenticate_by_email_password(email, password) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> put_session(:current_user, %{id: user.id})
        |> put_session(:password, password)
        |> configure_session(renew: true)
        |> redirect(to: Routes.user_event_path(conn, :my_schedule, user.id))

      {:error, :unauthorized} ->
        conn
        |> put_flash(:error, "Bad email/password combination!")
        |> redirect(to: Routes.page_path(conn, :new))
    end
  end

  def delete(conn, _) do
    conn
    |> delete_session(:password)
    |> delete_session(:current_user)
    |> put_flash(:info, "Bad email/password combination!")
    |> redirect(to: Routes.page_path(conn, :new))
  end
end

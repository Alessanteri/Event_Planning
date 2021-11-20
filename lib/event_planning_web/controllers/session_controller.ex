defmodule EventPlanningWeb.SessionController do
  use EventPlanningWeb, :controller

  alias EventPlanning.Accounts

  @static_password "123456789"

  def new(conn, _) do
    render(conn, "new.html")
  end

  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    if password == @static_password do
      case Accounts.authenticate_by_email_password(email, password) do
        {:ok, user} ->
          conn
          |> put_flash(:info, "Welcome back!")
          |> put_session(:current_user, %{id: user.id})
          |> configure_session(renew: true)
          |> redirect(to: Routes.user_event_path(conn, :my_schedule, user.id))

        {:error, :unauthorized} ->
          conn
          |> put_flash(:error, "Bad email/password combination!")
          |> redirect(to: Routes.session_path(conn, :new))
      end
    else
      conn
      |> put_flash(:error, "Error password!")
      |> redirect(to: Routes.session_path(conn, :new))
    end
  end

  def delete(conn, _) do
    conn
    |> delete_session(:current_user)
    |> put_flash(:info, "Bad email/password combination!")
    |> redirect(to: Routes.session_path(conn, :new))
  end
end

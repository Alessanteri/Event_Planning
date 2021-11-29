defmodule EventPlanningWeb.HomeController do
  use EventPlanningWeb, :controller

  @password "DgB4PPljWY"

  plug(:check_session_password)

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def check_session_password(conn, _opts) do
    if get_session(conn, :password) == @password do
      conn
    else
      conn =
        delete_session(conn, :password)
        |> redirect(to: Routes.page_path(conn, :login))
    end
  end
end

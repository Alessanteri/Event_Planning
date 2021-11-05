defmodule EventPlanningWeb.HomeController do
  use EventPlanningWeb, :controller

  @bearer_cookie_key "_hello_phoenix_key"
  plug(:check_session_password)

  def index(conn, _params) do
    message = get_session(conn, :message)

    if message != @bearer_cookie_key do
      redirect(conn, to: Routes.page_path(conn, :login))
    else
      render(conn, "index.html")
    end
  end

  def check_session_password(conn, _opts) do
    if get_session(conn, :message) == @bearer_cookie_key do
      conn
    else
      conn = delete_session(conn, :message)
      conn
    end
  end
end

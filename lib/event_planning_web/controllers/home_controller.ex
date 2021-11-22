defmodule EventPlanningWeb.HomeController do
  use EventPlanningWeb, :controller

  @bearer_cookie_key "_hello_phoenix_key"
  plug(:check_session_password)

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def check_session_password(conn, _opts) do
    if get_session(conn, :message) == @bearer_cookie_key do
      conn
    else
      conn =
        delete_session(conn, :message)
        |> redirect(to: Routes.page_path(conn, :login))
    end
  end
end

defmodule EventPlanningWeb.PageController do
  use EventPlanningWeb, :controller

  @bearer_cookie_key "_hello_phoenix_key"

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def login(conn, params) when params == %{} do
    render(conn, "login.html")
  end

  def login(conn, params) when params != %{} do
    %{"page" => %{"password" => password}} = params

    if password == @bearer_cookie_key do
      conn = put_session(conn, :message, @bearer_cookie_key)
      redirect(conn, to: Routes.home_path(conn, :index))
    else
      conn = delete_session(conn, :message)
      render(conn, "login.html")
    end
  end
end

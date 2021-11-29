defmodule EventPlanningWeb.PageController do
  use EventPlanningWeb, :controller

  @password "DgB4PPljWY"

  plug(:check_password)

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def login(conn, params) when params == %{} do
    render(conn, "login.html")
  end

  def login(conn, params) do
    %{"page" => %{"password" => password}} = params

    if password == @password do
      conn = put_session(conn, :password, @password)
      redirect(conn, to: Routes.home_path(conn, :index))
    else
      conn = delete_session(conn, :password)
      render(conn, "login.html")
    end
  end

  def check_password(conn, _opts) do
    if get_session(conn, :password) == @password do
      redirect(conn, to: Routes.home_path(conn, :index))
    else
      conn
    end
  end
end

defmodule EventPlanningWeb.HomeControllerTest do
  use EventPlanningWeb.ConnCase

  test "home page testing with an access key", %{conn: conn} do
    conn = session_conn()
    conn = put_session(conn, :password, "DgB4PPljWY")

  test "home page testing with an access key", %{conn: conn} do
    conn = session_conn()
    conn = put_session(conn, :password, "DgB4PPljWY")

    conn = get(conn, Routes.home_path(conn, :index))
    assert html_response(conn, 200) =~ "Hello World, from Phoenix!"
  end
end

defmodule EventPlanningWeb.HomeControllerTest do
  use EventPlanningWeb.ConnCase

  test "home page testing without an access key", %{conn: conn} do
    conn = get(conn, Routes.home_path(conn, :index))
    assert html_response(conn, 302) =~ Routes.page_path(conn, :login)
  end

  test "home page testing with an access key", %{conn: conn} do
    conn = session_conn()
    conn = put_session(conn, :message, "_hello_phoenix_key")
    conn = get(conn, Routes.home_path(conn, :index))
    assert html_response(conn, 200) =~ "Hello World, from Phoenix!"
  end
end

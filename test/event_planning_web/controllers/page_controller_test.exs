defmodule EventPlanningWeb.PageControllerTest do
  use EventPlanningWeb.ConnCase

  test "Post /", %{conn: conn} do
    conn = post(conn, Routes.page_path(conn, :login))
    # message = "_hello_phoenix_key"
    assert html_response(conn, 200) =~ "Password"
  end
end

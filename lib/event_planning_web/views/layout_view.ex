defmodule EventPlanningWeb.LayoutView do
  use EventPlanningWeb, :view

  def current_user(conn) do
    Plug.Conn.get_session(conn, :current_user)
  end
end

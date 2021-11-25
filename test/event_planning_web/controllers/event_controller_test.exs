defmodule EventPlanningWeb.EventControllerTest do
  use EventPlanningWeb.ConnCase

  alias EventPlanning.Operation.Event.Workflow

  @create_attrs %{repetition: "day", start_date: ~N[2010-04-17 14:00:00], enabled: true}
  @update_attrs %{repetition: "year", start_date: ~N[2011-05-18 15:01:01], enabled: true}
  @invalid_attrs %{repetition: nil, start_date: nil, enabled: false}

  def fixture(:event) do
    {:ok, event} = Workflow.create_event(@create_attrs)
    event
  end

  describe "new event" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.event_path(conn, :new))
      assert html_response(conn, 200) =~ "New Event"
    end
  end

  describe "create event" do
    test "redirects to my schedule when data is valid", %{conn: conn} do
      conn = post(conn, Routes.event_path(conn, :create), event: @create_attrs)
      assert redirected_to(conn) == Routes.event_path(conn, :my_schedule)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.event_path(conn, :create), event: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Event"
    end
  end

  describe "edit event" do
    setup [:create_event]

    test "renders form for editing chosen event", %{conn: conn, event: event} do
      conn = get(conn, Routes.event_path(conn, :edit, event))
      assert html_response(conn, 200) =~ "Edit Event"
    end
  end

  describe "update event" do
    setup [:create_event]

    test "redirects when data is valid", %{conn: conn, event: event} do
      conn = put(conn, Routes.event_path(conn, :update, event), event: @update_attrs)
      assert redirected_to(conn) == Routes.event_path(conn, :my_schedule)
    end

    test "renders errors when data is invalid", %{conn: conn, event: event} do
      conn = put(conn, Routes.event_path(conn, :update, event), event: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Event"
    end
  end

  describe "delete event" do
    setup [:create_event]

    test "deletes chosen event", %{conn: conn, event: event} do
      conn = delete(conn, Routes.event_path(conn, :delete, event))
      assert redirected_to(conn) == Routes.event_path(conn, :my_schedule)
    end
  end

  describe "my schedule" do
    setup [:create_event]

    test "open page", %{conn: conn, event: event} do
      conn = post(conn, Routes.event_path(conn, :my_schedule))
      assert html_response(conn, 200) =~ "Listing Events"
    end
  end

  defp create_event(_) do
    event = fixture(:event)
    %{event: event}
  end
end

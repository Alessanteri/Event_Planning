defmodule EventPlanning.Operation.Event.WorkflowTest do
  use EventPlanning.DataCase, async: true

  alias EventPlanning.Operation.Event.Workflow
  alias EventPlanning.Models.Event

  describe "events" do
    @valid_attrs %{repetition: "day", start_date: ~N[2010-04-17 14:00:00], enabled: true}
    @update_attrs %{repetition: "week", start_date: ~N[2011-05-18 15:01:01], enabled: true}
    @invalid_attrs %{repetition: nil, start_date: nil}

    def event_fixture(attrs \\ %{}) do
      {:ok, event} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Workflow.create_event()

      event
    end

    test "create_event/1 with valid data creates a event" do
      assert {:ok, %Event{} = event} = Workflow.create_event(@valid_attrs)
      assert event.repetition == "day"
      assert event.start_date == ~N[2010-04-17 14:00:00]
      assert event.enabled == true
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Workflow.create_event(@invalid_attrs)
    end

    test "get date for period for year" do
      event = event_fixture()
      dtstart = DateTime.now!("Europe/Minsk")

      dtend =
        Date.new!(
          DateTime.to_date(dtstart).year + 1,
          DateTime.to_date(dtstart).month,
          DateTime.to_date(dtstart).day
        )

      assert Workflow.get_date_for_period(DateTime.new!(dtend, DateTime.to_time(dtstart))) == [
               event
             ]
    end

    test "get date for period for month" do
      event = event_fixture()
      dtstart = DateTime.now!("Europe/Minsk")

      dtend =
        Date.new!(
          DateTime.to_date(dtstart).year,
          DateTime.to_date(dtstart).month + 1,
          DateTime.to_date(dtstart).day
        )

      assert Workflow.get_date_for_period(DateTime.new!(dtend, DateTime.to_time(dtstart))) == [
               event
             ]
    end

    test "get date for period for week" do
      event = event_fixture()

      assert Workflow.get_date_for_period(DateTime.add(DateTime.now!("Europe/Minsk"), 604_800)) ==
               [
                 event
               ]
    end
  end
end

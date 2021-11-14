defmodule EventPlanning.IAETest do
  use EventPlanning.DataCase

  alias EventPlanning.IAE

  describe "events" do
    alias EventPlanning.IAE.Event

    @valid_attrs %{repetition: "each day", start_date: ~N[2010-04-17 14:00:00]}
    @update_attrs %{repetition: "each week", start_date: ~N[2011-05-18 15:01:01]}
    @invalid_attrs %{repetition: nil, start_date: nil}

    def event_fixture(attrs \\ %{}) do
      {:ok, event} =
        attrs
        |> Enum.into(@valid_attrs)
        |> IAE.create_event()

      event
    end

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert IAE.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert IAE.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      assert {:ok, %Event{} = event} = IAE.create_event(@valid_attrs)
      assert event.repetition == "each day"
      assert event.start_date == ~N[2010-04-17 14:00:00]
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = IAE.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()
      assert {:ok, %Event{} = event} = IAE.update_event(event, @update_attrs)
      assert event.repetition == "each week"
      assert event.start_date == ~N[2011-05-18 15:01:01]
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = IAE.update_event(event, @invalid_attrs)
      assert event == IAE.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = IAE.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> IAE.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = IAE.change_event(event)
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

      assert IAE.get_date_for_period(DateTime.new!(dtend, DateTime.to_time(dtstart))) == [event]
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

      assert IAE.get_date_for_period(DateTime.new!(dtend, DateTime.to_time(dtstart))) == [event]
    end

    test "get date for period for week" do
      event = event_fixture()

      assert IAE.get_date_for_period(DateTime.add(DateTime.now!("Europe/Minsk"), 604_800)) == [
               event
             ]
    end
  end
end

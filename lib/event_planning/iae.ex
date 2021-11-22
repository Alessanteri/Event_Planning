defmodule EventPlanning.IAE do
  @moduledoc """
  The IAE context.
  """

  import Ecto.Query, warn: false
  alias EventPlanning.Repo

  alias EventPlanning.IAE.Event
  alias EventPlanning.Accounts.User

  import Ecto

  @doc """
  Returns the list of events.
  """
  def list_events do
    Event
    |> Repo.all()
  end

  @doc """
  Gets a single event.
  """
  def get_event!(id) do
    Event
    |> Repo.get!(id)
  end

  @doc """
  Creates a event.
  """
  def create_event(attrs \\ %{}) do
    %Event{}
    |> Event.changeset(attrs)
    |> Event.set_event_name_if_nil()
    |> Repo.insert()
  end

  @doc """
  Updates a event.
  """
  def update_event(%Event{} = event, attrs) do
    event
    |> Event.changeset(attrs)
    |> Event.set_event_name_if_nil()
    |> Repo.update()
  end

  @doc """
  Deletes a event.
  """
  def delete_event(%Event{} = event) do
    Repo.delete(event)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking event changes.
  """
  def change_event(%Event{} = event, attrs \\ %{}) do
    Event.changeset(event, attrs)
  end

  @doc """
  Configures the period of the returned data for a week.
  """
  def get_events_in_period_of_dates(categories_id) when categories_id == "week" do
    get_date_for_period(DateTime.add(DateTime.now!("Europe/Minsk"), 604_800))
  end

  @doc """
  Configures the period of the returned data for a month.
  """
  def get_events_in_period_of_dates(categories_id) when categories_id == "month" do
    dtstart = DateTime.now!("Europe/Minsk")

    dtend =
      Date.new!(
        DateTime.to_date(dtstart).year,
        DateTime.to_date(dtstart).month + 1,
        DateTime.to_date(dtstart).day
      )

    get_date_for_period(DateTime.new!(dtend, DateTime.to_time(dtstart)))
  end

  @doc """
  Configures the period of the returned data for a year.
  """
  def get_events_in_period_of_dates(categories_id) when categories_id == "year" do
    dtstart = DateTime.now!("Europe/Minsk")

    dtend =
      Date.new!(
        DateTime.to_date(dtstart).year + 1,
        DateTime.to_date(dtstart).month,
        DateTime.to_date(dtstart).day
      )

    get_date_for_period(DateTime.new!(dtend, DateTime.to_time(dtstart)))
  end

  @doc """
  Returns a list of events for a certain time.
  """
  def get_date_for_period(dtend) do
    Ecto.Query.from(e in Event, where: e.start_date <= ^dtend)
    |> Repo.all()
  end
end

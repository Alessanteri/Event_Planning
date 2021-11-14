defmodule EventPlanning.IAE do
  @moduledoc """
  The IAE context.
  """

  import Ecto.Query, warn: false
  alias EventPlanning.Repo

  alias EventPlanning.IAE.Event

  @doc """
  Returns the list of events.
  """
  def list_events do
    Repo.all(Event)
  end

  @doc """
  Gets a single event.
  """
  def get_event!(id), do: Repo.get!(Event, id)

  @doc """
  Creates a event.
  """
  def create_event(attrs \\ %{}) do
    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a event.
  """
  def update_event(%Event{} = event, attrs) do
    event
    |> Event.changeset(attrs)
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

  def get_events_in_period_of_dates(categories_id) when categories_id == "week" do
    get_date_for_period(DateTime.add(DateTime.now!("Europe/Minsk"), 604_800))
  end

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

  def get_date_for_period(dtend) do
    Ecto.Query.from(e in Event, where: e.start_date <= ^dtend)
    |> Repo.all()
  end

  def get_upcoming_events() do
    Ecto.Query.from(Event)
    |> Repo.all()
  end
end

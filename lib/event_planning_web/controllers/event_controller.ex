defmodule EventPlanningWeb.EventController do
  use EventPlanningWeb, :controller

  alias EventPlanning.Repo

  alias EventPlanning.IAE
  alias EventPlanning.IAE.Event

  alias EventPlanning.Accounts
  alias EventPlanning.Accounts.User

  import Ecto
  import Ecto.Query

  plug(:assign_user)
  plug(:authorize_user)

  # plug :require_existing_author
  # plug :authorize_page when action in [:edit, :update, :delete]

  def new(conn, params) do
    changeset =
      conn.assigns[:user]
      |> build_assoc(:event)
      |> Event.changeset(params)

    render(conn, "new.html", changeset: changeset)
  end

  @doc """
  Create of a new event.
  """
  def create(conn, %{"event" => event_params}) do
    changeset =
      conn.assigns[:user]
      |> build_assoc(:event)
      |> Event.changeset(event_params)

    case Repo.insert(changeset) do
      {:ok, _event} ->
        conn
        |> put_flash(:info, "Event created successfully.")
        |> redirect(to: Routes.user_event_path(conn, :my_schedule, conn.assigns[:user]))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  @doc """
  Show  enevt.
  """
  def show(conn, %{"id" => id}) do
    if Ability.can?(%Event{}, :read, get_session(conn, :current_user)) do
      event = IAE.get_event!(id)
      render(conn, "show.html", event: event)
    else
      event = Repo.get!(assoc(conn.assigns[:user], :event), id)
      render(conn, "show.html", event: event)
    end
  end

  @doc """
  Edit event.
  """
  def edit(conn, %{"id" => id}) do
    event = IAE.get_event!(id)
    changeset = IAE.change_event(event)
    render(conn, "edit.html", event: event, changeset: changeset)
  end

  @doc """
  Update event.
  """
  def update(conn, %{"id" => id, "event" => event_params}) do
    event = IAE.get_event!(id)

    case IAE.update_event(event, event_params) do
      {:ok, _event} ->
        conn
        |> put_flash(:info, "Event updated successfully.")
        |> redirect(to: Routes.user_event_path(conn, :my_schedule, conn.assigns[:user]))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", event: event, changeset: changeset)
    end
  end

  @doc """
  Delete event.
  """
  def delete(conn, %{"id" => id}) do
    event = IAE.get_event!(id)
    {:ok, _event} = IAE.delete_event(event)

    conn
    |> put_flash(:info, "Event deleted successfully.")
    |> redirect(to: Routes.user_event_path(conn, :my_schedule, conn.assigns[:user]))
  end

  @doc """
  Show events schedule.
  """
  def my_schedule(conn, params) when params == %{} do
    call_up_my_schedule(conn, "week")
  end

  def my_schedule(conn, params) when params != %{} do
    %{"user_id" => user_id} = conn.params
    categories_id = "week"

    if conn.body_params == %{} do
      categories_id
      call_up_my_schedule(conn, categories_id)
    else
      %{"page" => %{"categories_id" => categories_id}} = conn.body_params
      call_up_my_schedule(conn, categories_id)
    end
  end

  def call_up_my_schedule(conn, categories_id) do
    categories = ["week", "month", "year"]

    events = check_ability(conn, categories_id)

    Enum.each(events, fn x -> IO.puts(x.name) end)

    render(conn, "my_schedule.html",
      event_without_duplicate: return_data_without_duplicate(events),
      event_with_duplicate: return_data_duplicate(events),
      categories: categories
    )
  end

  def check_ability(conn, categories_id) do
    if Ability.can?(%Event{}, :read, get_session(conn, :current_user)) do
      events =
        select_events_for_date(
          create_events_greater_today(IAE.get_events_in_period_of_dates(categories_id)),
          categories_id
        )
    else
      events =
        select_events_for_date(
          create_events_greater_today(Repo.all(assoc(conn.assigns[:user], :event))),
          categories_id
        )
    end
  end

  @doc """
  Selection of meetings by parameter.
  """
  def select_events_for_date(events, categories_id) when categories_id == "week" do
    events
    |> Enum.reject(fn x ->
      DateTime.diff(
        DateTime.add(DateTime.now!("Europe/Minsk"), 604_800),
        DateTime.from_naive!(x.start_date, "Europe/Minsk")
      ) < 0
    end)
  end

  def select_events_for_date(events, categories_id) when categories_id == "month" do
    date_now = DateTime.now!("Europe/Minsk")

    date_end = %DateTime{
      year: date_now.year,
      month: date_now.month + 1,
      day: date_now.day,
      zone_abbr: "AMT",
      hour: date_now.hour,
      minute: date_now.minute,
      second: date_now.second,
      utc_offset: -14400,
      std_offset: 0,
      time_zone: "Europe/Minsk"
    }

    events
    |> Enum.reject(fn x ->
      DateTime.diff(DateTime.from_naive!(x.start_date, "Europe/Minsk"), date_end) > 0
    end)
  end

  def select_events_for_date(events, categories_id) when categories_id == "year" do
    date_end = create_date_end(DateTime.now!("Europe/Minsk"))

    events
    |> Enum.reject(fn x ->
      DateTime.diff(DateTime.from_naive!(x.start_date, "Europe/Minsk"), date_end) > 0
    end)
  end

  @doc """
  Creates a date one year from today.
  """
  def create_date_end(date) do
    %DateTime{
      year: date.year + 1,
      month: date.month,
      day: date.day,
      zone_abbr: "AMT",
      hour: date.hour,
      minute: date.minute,
      second: date.second,
      utc_offset: -14400,
      std_offset: 0,
      time_zone: "Europe/Minsk"
    }
  end

  @doc """
  Creates events greater than today.
  """
  def create_events_greater_today(events) do
    events
    |> Enum.map(fn x ->
      %{
        x
        | start_date:
            DateTime.to_naive(
              find_nearest_recurring_event(
                DateTime.from_naive!(x.start_date, "Europe/Minsk"),
                DateTime.now!("Europe/Minsk"),
                x.repetition
              )
            )
      }
    end)
  end

  @doc """
  Find the nearest event recurring.
  """
  def find_nearest_recurring_event(dt1, dt2, categories_id) when categories_id == "each year" do
    if DateTime.diff(dt1, dt2) > 0 do
      dt1
    else
      dt1 = create_date_end(dt1)

      find_nearest_recurring_event(dt1, dt2, categories_id)
    end
  end

  def find_nearest_recurring_event(dt1, dt2, categories_id) when categories_id == "each month" do
    if DateTime.diff(dt1, dt2) > 0 do
      dt1
    else
      dt1 =
        DateTime.add(
          dt1,
          86400 *
            Calendar.ISO.days_in_month(DateTime.to_date(dt1).year, DateTime.to_date(dt1).month)
        )

      find_nearest_recurring_event(dt1, dt2, categories_id)
    end
  end

  def find_nearest_recurring_event(dt1, dt2, categories_id) when categories_id == "each week" do
    if DateTime.diff(dt1, dt2) > 0 do
      dt1
    else
      dt1 = DateTime.add(dt1, 604_800)

      find_nearest_recurring_event(dt1, dt2, categories_id)
    end
  end

  def find_nearest_recurring_event(dt1, dt2, categories_id) when categories_id == "each day" do
    if DateTime.diff(dt1, dt2) > 0 do
      dt1
    else
      dt1 = DateTime.add(dt1, 86400)

      find_nearest_recurring_event(dt1, dt2, categories_id)
    end
  end

  @doc """
  Returns non-duplicate events.
  """
  def return_data_without_duplicate(events) do
    Enum.reduce(events, [], fn x, acc ->
      if count_number_of_repetitions_data_start(events, x) == 0 do
        List.insert_at(acc, -1, x)
      else
        acc
      end
    end)
  end

  @doc """
  Returns duplicate events.
  """
  def return_data_duplicate(events) do
    Enum.reduce(events, [], fn x, acc ->
      if count_number_of_repetitions_data_start(events, x) != 0 do
        List.insert_at(acc, -1, x)
      else
        acc
      end
    end)
  end

  @doc """
  Counts the number of repetitions of events.
  """
  def count_number_of_repetitions_data_start(events, item) do
    Enum.reduce(events, -1, fn y, ac ->
      if item.start_date == y.start_date do
        ac + 1
      else
        ac
      end
    end)
  end

  @doc """
  Returns the next event and the time before it.
  """
  def next_event(conn, _params) do
    events = create_events_greater_today(Repo.all(assoc(conn.assigns[:user], :event)))

    if events == [] do
      render(conn, "next_event.html",
        events: [],
        time_to_next_event: 0
      )
    else
      min_date_value_events =
        Enum.min_by(
          events,
          &DateTime.diff(
            DateTime.from_naive!(&1.start_date, "Europe/Minsk"),
            DateTime.now!("Europe/Minsk")
          )
        )

      render(conn, "next_event.html",
        events: min_date_value_events,
        time_to_next_event:
          DateTime.diff(
            DateTime.from_naive!(min_date_value_events.start_date, "Europe/Minsk"),
            DateTime.now!("Europe/Minsk")
          )
      )
    end
  end

  defp assign_user(conn, _opts) do
    case conn.params do
      %{"user_id" => user_id} ->
        case Repo.get(Accounts.User, user_id) do
          nil -> invalid_user(conn)
          user -> assign(conn, :user, user)
        end

      _ ->
        invalid_user(conn)
    end
  end

  defp invalid_user(conn) do
    conn
    |> put_flash(:error, "Invalid user!")
    |> redirect(to: Routes.session_path(conn, :new))
    |> halt
  end

  defp authorize_user(conn, _opts) do
    user = get_session(conn, :current_user)

    if user && Integer.to_string(user.id) == conn.params["user_id"] do
      conn
    else
      conn
      |> put_flash(:error, "You are not authorized to modify that post!")
      |> redirect(to: Routes.session_path(conn, :new))
      |> halt()
    end
  end
end

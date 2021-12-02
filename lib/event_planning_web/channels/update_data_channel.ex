defmodule EventPlanningWeb.UpdateDataChannel do
  use EventPlanningWeb, :channel

  alias EventPlanning.Operation.Event.Workflow
  alias EventPlanning.Models.Event
  alias EventPlanning.Models.User

  import Phoenix.HTML
  import Phoenix.HTML.Link

  alias EventPlanning.Repo

  import Ecto

  intercept(["new_event", "update_event", "delete_event"])

  def join("update_data:lobby", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  def handle_in("new_event", %{"message" => message}, socket) do
    %{
      "id_user" => id_user
    } = message

    changeset =
      Repo.get!(User, String.to_integer(String.replace(id_user, ~r/[^0-9]/, "")))
      |> build_assoc(:event)
      |> Event.changeset(create_attrs_event(message))

    {:ok, event} = Repo.insert(changeset)

    broadcast(socket, "new_event", %{id: event.id})
    {:noreply, socket}
  end

  def handle_out("new_event", msg, socket) do
    push(
      socket,
      "new_event",
      Map.merge(
        msg,
        %{html_template: generate_html(Repo.get(Event, msg.id))}
      )
    )

    {:noreply, socket}
  end

  def handle_in("update_event", %{"message" => message}, socket) do
    %{
      "id" => id,
      "name" => name
    } = message

    {:ok, event} = Workflow.update_event(Repo.get(Event, id), create_attrs_event(message))
    broadcast(socket, "update_event", %{id: event.id})
    {:noreply, socket}
  end

  def handle_out("update_event", msg, socket) do
    push(
      socket,
      "update_event",
      Map.merge(msg, %{html_template: generate_html(Repo.get(Event, msg.id))})
    )

    {:noreply, socket}
  end

  def handle_in("delete_event", %{"message" => message}, socket) do
    broadcast(socket, "delete_event", %{id: message})
    {:noreply, socket}
  end

  def handle_out("delete_event", msg, socket) do
    push(
      socket,
      "delete_event",
      Map.merge(msg, %{id: String.replace(msg.id, ~r/[^0-9]/, "")})
    )

    {:noreply, socket}
  end

  def generate_html(event) do
    ~E"""
    <td><%= event.name %></td>
    <%= if event.repetition == nil do %>
      <td><%= event.start_date %></td>
    <% else %>
      <td><%= puts_date_start(event.start_date, event.repetition) %></td>
    <% end %>
    <%= if event.enabled do%>
      <%= if event.repetition == nil do%>
        <td>No repetition</td>
      <%= else %>
        <td><%= event.repetition %></td>
      <% end %>
    <% else %>
      <td>No repetition</td>
    <% end %>
    <td>
      <span><%= link "Show", to: "event/" <> Integer.to_string(event.id) %></span>
    </td>
    """
    |> safe_to_string()
  end

  def puts_date_start(start_date, repetition) do
    DateTime.to_naive(
      find_nearest_recurring_event(
        DateTime.from_naive!(start_date, "Europe/Minsk"),
        DateTime.now!("Europe/Minsk"),
        repetition
      )
    )
  end

  def find_nearest_recurring_event(dt1, dt2, categories_id) when categories_id == "year" do
    if DateTime.diff(dt1, dt2) > 0 do
      dt1
    else
      dt1 = create_date_end(dt1)

      find_nearest_recurring_event(dt1, dt2, categories_id)
    end
  end

  @doc """
  Find the nearest event recurring every month.
  """
  def find_nearest_recurring_event(dt1, dt2, categories_id) when categories_id == "month" do
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

  @doc """
  Find the nearest event recurring every week.
  """
  def find_nearest_recurring_event(dt1, dt2, categories_id) when categories_id == "week" do
    if DateTime.diff(dt1, dt2) > 0 do
      dt1
    else
      dt1 = DateTime.add(dt1, 604_800)

      find_nearest_recurring_event(dt1, dt2, categories_id)
    end
  end

  @doc """
  Find the nearest event recurring every day.
  """
  def find_nearest_recurring_event(dt1, dt2, categories_id) when categories_id == "day" do
    if DateTime.diff(dt1, dt2) > 0 do
      dt1
    else
      dt1 = DateTime.add(dt1, 86400)

      find_nearest_recurring_event(dt1, dt2, categories_id)
    end
  end

  def find_nearest_recurring_event(dt1, dt2, categories_id) when categories_id == "" do
    dt1
  end

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

  defp create_attrs_event(message) do
    %{
      "date_year" => date_year,
      "date_month" => date_month,
      "date_day" => date_day,
      "date_hour" => date_hour,
      "date_minute" => date_minute,
      "repetition" => repetition,
      "enabled" => enabled,
      "name" => name
    } = message

    datetime =
      DateTime.new!(
        Date.new!(
          String.to_integer(date_year),
          String.to_integer(date_month),
          String.to_integer(date_day)
        ),
        Time.new!(String.to_integer(date_hour), String.to_integer(date_minute), 0, 0)
      )

    %{start_date: datetime, enabled: enabled, repetition: repetition, name: name}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end

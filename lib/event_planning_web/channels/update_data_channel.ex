defmodule EventPlanningWeb.UpdateDataChannel do
  use EventPlanningWeb, :channel

  alias EventPlanning.Operation.Event.Workflow

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

  def handle_in("adding_new_event", %{"message" => message}, socket) do
    %{
      "date_year" => date_year,
      "date_month" => date_month,
      "date_day" => date_day,
      "date_hour" => date_hour,
      "date_minute" => date_minute,
      "repetition" => repetition,
      "enabled" => enabled
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

    attrs = %{start_date: datetime, enabled: enabled, repetition: repetition}

    Workflow.create_event(attrs)

    broadcast(socket, "adding_new_event", %{content: attrs})
    {:noreply, socket}
  end

  # def handle_out("adding_new_event", payload, socket) do
  #   push(socket, "adding_new_event", payload)
  #   {:noreply, socket}
  # end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end

defmodule EventPlanningWeb.UpdateDataChannel do
  use EventPlanningWeb, :channel

  @impl true
  def join("update_data:lobby", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (update_data:lobby).

  def handle_in("message:add", %{"message" => content}, socket) do
    broadcast!(socket, "update_data:lobby:new_message", %{content: content})
    IO.puts(content)
    {:noreply, socket}
  end

  # def handle_in("message:add", %{"message" => content}, socket) do
  #   broadcast!(socket, "update_data:lobby:new_message", %{content: content})
  #   IO.puts(content)
  #   {:reply, :ok, socket}
  # end

  # def handle_in("date_year:add", %{"date_year" => content}, socket) do
  #   broadcast!(socket, "update_data:lobby:start_date_year", %{content: content})
  #   IO.puts(content)
  #   {:reply, :ok, socket}
  # end

  # def handle_in("date_month:add", %{"date_month" => content}, socket) do
  #   broadcast!(socket, "update_data:lobby:start_date_month", %{content: content})
  #   IO.puts(content)
  #   {:reply, :ok, socket}
  # end

  # def handle_in("date_hour:add", %{"date_hour" => content}, socket) do
  #   broadcast!(socket, "update_data:lobby:start_date_day", %{content: content})
  #   IO.puts(content)
  #   {:reply, :ok, socket}
  # end

  # def handle_in("date_minute:add", %{"date_minute" => content}, socket) do
  #   broadcast!(socket, "update_data:lobby:start_date_hour", %{content: content})
  #   IO.puts(content)
  #   {:reply, :ok, socket}
  # end

  # def handle_in("date_day:add", %{"date_day" => content}, socket) do
  #   broadcast!(socket, "update_data:lobby:start_date_minute", %{content: content})
  #   IO.puts(content)
  #   {:reply, :ok, socket}
  # end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end

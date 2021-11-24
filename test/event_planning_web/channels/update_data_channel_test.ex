defmodule EventPlanningWeb.UpdateDataChannelTest do
  use EventPlanningWeb.ChannelCase

  setup do
    {:ok, _, socket} =
      EventPlanningWeb.UserSocket
      |> socket("user_id", %{some: :assign})
      |> subscribe_and_join(EventPlanningWeb.UpdateDataChannel, "update_data:lobby")

    %{socket: socket}
  end

  test "ping replies with status ok", %{socket: socket} do
    ref = push(socket, "ping", %{"hello" => "there"})
    assert_reply(ref, :ok, %{"hello" => "there"})
  end

  test "broadcasts are pushed to the client", %{socket: socket} do
    broadcast_from!(socket, "broadcast", %{"some" => "data"})
    assert_push("broadcast", %{"some" => "data"})
  end
end

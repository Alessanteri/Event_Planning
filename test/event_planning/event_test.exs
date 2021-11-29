defmodule EventPlanning.IAE.EventTest do
  use EventPlanning.DataCase, async: true
  alias EventPlanning.IAE.Event

  test "wrong choice of repetition" do
    changeset =
      Event.changeset(%Event{}, %{
        repetition: "some repetition",
        start_date: ~N[2010-04-17 14:00:00]
      })

    assert %{repetition: ["is invalid"]} = errors_on(changeset)
  end

  test "date not entered" do
    changeset =
      Event.changeset(%Event{}, %{
        repetition: "each week",
        start_date: nil
      })

    assert %{start_date: ["can't be blank"]} = errors_on(changeset)
  end

  test "all data is correct" do
    changeset =
      Event.changeset(%Event{}, %{
        repetition: "each year",
        start_date: ~N[2012-10-01 10:17:00]
      })

    assert %{} = errors_on(changeset)
  end

  test "all data is incorrect" do
    changeset =
      Event.changeset(%Event{}, %{
        repetition: "each ",
        start_date: nil
      })

    assert %{start_date: ["can't be blank"], repetition: ["is invalid"]} = errors_on(changeset)
  end
end

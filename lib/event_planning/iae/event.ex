defmodule EventPlanning.IAE.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field(:start_date, :naive_datetime)
    field(:repetition, :string)

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:start_date, :repetition])
    |> validate_required([:start_date, :repetition])
    |> validate_inclusion(:repetition, [
      "each day",
      "each week",
      "each month",
      "each year",
      "disable"
    ])
  end
end

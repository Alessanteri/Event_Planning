defmodule EventPlanning.Models.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field(:start_date, :naive_datetime)
    field(:repetition, :string)
    field(:enabled, :boolean, default: false)

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:start_date, :repetition, :enabled])
    |> validate_required([:start_date, :enabled])
    |> validate_inclusion(:repetition, [
      "day",
      "week",
      "month",
      "year",
      nil
    ])
  end
end

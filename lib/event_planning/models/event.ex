defmodule EventPlanning.Models.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field(:start_date, :naive_datetime)
    field(:repetition, :string)
    field(:name, :string)
    field(:enabled, :boolean, default: false)
    belongs_to(:user, User)

    # timestamps()
  end

  def set_event_name_if_nil(changeset) do
    case get_field(changeset, :name) do
      nil -> put_change(changeset, :name, create_random_name())
      _else -> changeset
    end
  end

  defp create_random_name() do
    symbols = Enum.concat([?0..?9, ?A..?Z, ?a..?z])
    symbol_count = Enum.count(symbols)
    s = for _ <- 1..6, into: "", do: <<Enum.at(symbols, :crypto.rand_uniform(0, symbol_count))>>
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:start_date, :repetition, :name, :enabled])
    |> validate_required([:start_date, :enabled])
    |> set_event_name_if_nil()
    |> unique_constraint(:name, name: :events_name_index, message: "This name already exists!")
    |> validate_inclusion(:repetition, [
      "day",
      "week",
      "month",
      "year",
      nil
    ])
  end
end

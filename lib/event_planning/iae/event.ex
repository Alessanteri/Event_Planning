defmodule EventPlanning.IAE.Event do
  use Ecto.Schema
  import Ecto.Changeset
  alias EventPlanning.Accounts.User

  schema "events" do
    field(:start_date, :naive_datetime)
    field(:repetition, :string)
    field(:name, :string)
    belongs_to(:user, User)

    timestamps()
  end

  def set_event_name_if_nil(changeset) do
    name = get_field(changeset, :name)

    if is_nil(name) do
      put_change(changeset, :name, create_random_name)
    else
      changeset
    end
  end

  def create_random_name() do
    symbols = Enum.concat([?0..?9, ?A..?Z, ?a..?z])
    symbol_count = Enum.count(symbols)
    s = for _ <- 1..6, into: "", do: <<Enum.at(symbols, :crypto.rand_uniform(0, symbol_count))>>
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:start_date, :repetition, :name])
    |> validate_required([:start_date, :repetition])
    |> set_event_name_if_nil()
    |> unique_constraint(:name, name: :events_name_index, message: "This name already exists!")
    |> validate_inclusion(:repetition, [
      "each day",
      "each week",
      "each month",
      "each year",
      "disable"
    ])
  end
end

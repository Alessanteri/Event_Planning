defmodule EventPlanning.Models.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias EventPlanning.Models.Event

  schema "users" do
    field(:email, :string)
    field(:role, :string)
    has_many(:event, Event)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :role])
    |> validate_required([:email, :role])
    |> validate_inclusion(:role, ["admin", "user"])
    |> unique_constraint(:email, name: :users_email_index, message: "This email is registered!")
  end
end

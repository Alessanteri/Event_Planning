defmodule EventPlanning.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :password, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:password])
    |> validate_required([:password])
  end
end

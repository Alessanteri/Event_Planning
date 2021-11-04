defmodule EventPlanning.Page do
  use Ecto.Schema
  import Ecto.Changeset

  schema "password_table" do

    timestamps()
  end

  @doc false
  def changeset(page, attrs) do
    page
    |> cast(attrs, [])
    |> validate_required([])
  end
end

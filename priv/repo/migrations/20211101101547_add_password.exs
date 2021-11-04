defmodule EventPlanning.Repo.Migrations.AddPassword do
  use Ecto.Migration

  def change do
    create table(:password_table) do
      add(:password, :string, null: false)
    end
  end
end

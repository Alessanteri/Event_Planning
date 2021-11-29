defmodule EventPlanning.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add(:start_date, :naive_datetime, null: false)
      add(:repetition, :string, null: false)
      add(:name, :string)
      add(:user_id, references(:users, on_delete: :delete_all), null: false)

      # timestamps()
    end

    create(unique_index(:events, [:name]))
    create(index(:events, [:user_id]))
  end
end

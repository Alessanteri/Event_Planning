defmodule EventPlanning.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add(:start_date, :naive_datetime)
      add(:repetition, :string)
      add(:enabled, :boolean)

      timestamps()
    end
  end
end

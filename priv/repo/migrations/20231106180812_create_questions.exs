defmodule AnonymousMessages.Repo.Migrations.CreateQuestions do
  use Ecto.Migration

  def change do
    create table(:questions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, on_delete: :nothing, type: :integer), required: true
      add :description, :string, required: true

      timestamps(type: :utc_datetime)
    end

    create index(:questions, [:user_id])
  end
end

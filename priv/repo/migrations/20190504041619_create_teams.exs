defmodule TournamentsApi.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:teams, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :tournament_id, references(:tournaments, on_delete: :nothing, type: :uuid)

      timestamps()
    end

    create index(:teams, [:tournament_id])
  end
end

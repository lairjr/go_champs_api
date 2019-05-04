defmodule TournamentsApi.Repo.Migrations.CreateTournamentGroups do
  use Ecto.Migration

  def change do
    create table(:tournament_groups, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :tournament_id, references(:tournaments, on_delete: :nothing, type: :uuid)

      timestamps()
    end

    create index(:tournament_groups, [:tournament_id])
  end
end

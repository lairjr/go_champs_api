defmodule TournamentsApi.Repo.Migrations.CreateTournamentTeams do
  use Ecto.Migration

  def change do
    create table(:tournament_teams, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :stats, :map
      add :tournament_id, references(:tournaments, on_delete: :nothing, type: :uuid)
      add :tournament_group_id, references(:tournament_groups, on_delete: :nothing, type: :uuid)

      timestamps()
    end

    create index(:tournament_teams, [:tournament_id])
  end
end

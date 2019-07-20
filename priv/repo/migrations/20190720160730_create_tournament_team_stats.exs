defmodule TournamentsApi.Repo.Migrations.CreateTournamentTeamStats do
  use Ecto.Migration

  def change do
    create table(:tournament_team_stats, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :value, :string
      add :tournament_team_id, references(:tournament_teams, on_delete: :nothing, type: :uuid)

      timestamps()
    end

    create index(:tournament_team_stats, [:tournament_team_id])
  end
end

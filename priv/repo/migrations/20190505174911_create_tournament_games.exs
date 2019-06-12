defmodule TournamentsApi.Repo.Migrations.CreateTournamentGames do
  use Ecto.Migration

  def change do
    create table(:tournament_games, primary_key: false) do
      add :id, :uuid, primary_key: true

      add :home_score, :integer
      add :away_score, :integer
      add :location, :string
      add :datetime, :utc_datetime

      add :away_team_id, references(:tournament_teams, on_delete: :nothing, type: :uuid)
      add :home_team_id, references(:tournament_teams, on_delete: :nothing, type: :uuid)
      add :tournament_id, references(:tournaments, on_delete: :nothing, type: :uuid)

      timestamps()
    end

    create index(:tournament_games, [:tournament_id])
    create index(:tournament_games, [:away_team_id])
    create index(:tournament_games, [:home_team_id])
  end
end

defmodule TournamentsApi.Repo.Migrations.CreateTournamentGames do
  use Ecto.Migration

  def change do
    create table(:tournament_games, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :tournament_id, references(:tournaments, on_delete: :nothing, type: :uuid)
      add :game_id, references(:games, on_delete: :nothing, type: :uuid)

      timestamps()
    end

    create index(:tournament_games, [:tournament_id])
    create index(:tournament_games, [:game_id])
  end
end

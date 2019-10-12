defmodule TournamentsApi.Repo.Migrations.ChangeReferenceFromTournamentToPhase do
  use Ecto.Migration

  def change do
    alter table(:tournament_stats) do
      add :phase_id, references(:phases, on_delete: :nothing, type: :uuid)
    end

    create index(:tournament_stats, [:phase_id])
    create unique_index(:tournament_stats, [:id, :phase_id])

    alter table(:tournament_games) do
      add :phase_id, references(:phases, on_delete: :nothing, type: :uuid)
    end

    create index(:tournament_games, [:phase_id])
    create unique_index(:tournament_games, [:id, :phase_id])
  end
end

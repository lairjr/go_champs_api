defmodule TournamentsApi.Repo.Migrations.ChangeReferenceFromTournamentToPhase do
  use Ecto.Migration

  def change do
    alter table(:tournament_stats) do
      add :tournament_phase_id, references(:tournament_phases, on_delete: :nothing, type: :uuid)
    end

    create index(:tournament_stats, [:tournament_phase_id])
    create unique_index(:tournament_stats, [:id, :tournament_phase_id])

    alter table(:tournament_games) do
      add :tournament_phase_id, references(:tournament_phases, on_delete: :nothing, type: :uuid)
    end

    create index(:tournament_games, [:tournament_phase_id])
    create unique_index(:tournament_games, [:id, :tournament_phase_id])

    alter table(:tournament_groups) do
      add :tournament_phase_id, references(:tournament_phases, on_delete: :nothing, type: :uuid)
    end

    create index(:tournament_groups, [:tournament_phase_id])
    create unique_index(:tournament_groups, [:id, :tournament_phase_id])
  end
end

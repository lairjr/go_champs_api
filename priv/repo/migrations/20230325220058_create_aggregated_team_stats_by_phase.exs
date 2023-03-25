defmodule GoChampsApi.Repo.Migrations.CreateAggregatedTeamStatsByPhase do
  use Ecto.Migration

  def change do
    create table(:aggregated_team_stats_by_phase, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :tournament_id, references(:tournaments, on_delete: :nothing, type: :uuid)
      add :phase_id, references(:phases, on_delete: :nothing, type: :uuid)
      add :team_id, references(:teams, on_delete: :nothing, type: :uuid)
      add :stats, :map

      timestamps()
    end

    create index(:aggregated_team_stats_by_phase, [:phase_id])
    create index(:aggregated_team_stats_by_phase, [:tournament_id])
    create index(:aggregated_team_stats_by_phase, [:team_id])
  end
end

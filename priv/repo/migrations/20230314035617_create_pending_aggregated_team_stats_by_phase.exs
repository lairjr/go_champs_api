defmodule GoChampsApi.Repo.Migrations.CreatePendingAggregatedTeamStatsByPhase do
  use Ecto.Migration

  def change do
    create table(:pending_aggregated_team_stats_by_phase, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :tournament_id, references(:tournaments, on_delete: :nothing, type: :uuid)
      add :phase_id, references(:phases, on_delete: :nothing, type: :uuid)

      timestamps()
    end
  end
end

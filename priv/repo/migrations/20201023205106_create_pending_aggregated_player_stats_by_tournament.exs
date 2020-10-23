defmodule GoChampsApi.Repo.Migrations.CreatePendingAggregatedPlayerStatsByTournament do
  use Ecto.Migration

  def change do
    create table(:pending_aggregated_player_stats_by_tournament, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :tournament_id, references(:tournaments, on_delete: :nothing, type: :uuid)

      timestamps()
    end
  end
end

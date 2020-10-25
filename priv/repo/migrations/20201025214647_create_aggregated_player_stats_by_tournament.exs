defmodule GoChampsApi.Repo.Migrations.CreateAggregatedPlayerStatsByTournament do
  use Ecto.Migration

  def change do
    create table(:aggregated_player_stats_by_tournament, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :tournament_id, references(:tournaments, on_delete: :nothing, type: :uuid)
      add :player_id, references(:players, on_delete: :nothing, type: :uuid)
      add :stats, :map

      timestamps()
    end

    create index(:aggregated_player_stats_by_tournament, [:tournament_id])
    create index(:aggregated_player_stats_by_tournament, [:player_id])
  end
end

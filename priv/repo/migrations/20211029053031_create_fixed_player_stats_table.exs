defmodule GoChampsApi.Repo.Migrations.CreateFixedPlayerStatsTable do
  use Ecto.Migration

  def change do
    create table(:fixed_player_stats_table, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :tournament_id, references(:tournaments, on_delete: :nothing, type: :uuid)
      add :stat_id, :uuid

      add :player_stats, :map

      timestamps()
    end

    create index(:fixed_player_stats_table, [:tournament_id])
  end
end

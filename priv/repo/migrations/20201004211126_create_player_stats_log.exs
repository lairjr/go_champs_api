defmodule GoChampsApi.Repo.Migrations.CreatePlayerStatsLog do
  use Ecto.Migration

  def change do
    create table(:player_stats_log, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :stats, :map

      add :tournament_id, references(:tournaments, on_delete: :nothing, type: :uuid)
      add :phase_id, references(:phases, on_delete: :nothing, type: :uuid)
      add :team_id, references(:teams, on_delete: :nothing, type: :uuid)
      add :game_id, references(:games, on_delete: :nothing, type: :uuid)
      add :player_id, references(:players, on_delete: :nothing, type: :uuid)

      timestamps()
    end

    create index(:player_stats_log, [:tournament_id])
    create index(:player_stats_log, [:phase_id])
    create index(:player_stats_log, [:team_id])
    create index(:player_stats_log, [:game_id])
    create index(:player_stats_log, [:player_id])
  end
end

defmodule GoChampsApi.Repo.Migrations.AddHasAggregatedPlayerStatsInTournament do
  use Ecto.Migration

  def change do
    alter table(:tournaments) do
      add :has_aggregated_player_stats, :boolean, default: false
    end
  end
end

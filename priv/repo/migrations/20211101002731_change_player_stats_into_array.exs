defmodule GoChampsApi.Repo.Migrations.ChangePlayerStatsIntoArray do
  use Ecto.Migration

  def change do
    alter table(:fixed_player_stats_table) do
      remove :player_stats
      add :player_stats, {:array, :map}
    end
  end
end

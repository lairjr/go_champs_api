defmodule GoChampsApi.Repo.Migrations.AddPlayerStatsInTournament do
  use Ecto.Migration

  def change do
    alter table(:tournaments) do
      add :player_stats, {:array, :map}
    end
  end
end

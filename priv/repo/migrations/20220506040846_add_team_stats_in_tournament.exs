defmodule GoChampsApi.Repo.Migrations.AddTeamStatsInTournament do
  use Ecto.Migration

  def change do
    alter table(:tournaments) do
      add :team_stats, {:array, :map}
    end
  end
end

defmodule GoChampsApi.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create table(:games, primary_key: false) do
      add :id, :uuid, primary_key: true

      add :home_score, :integer
      add :away_score, :integer
      add :location, :string
      add :datetime, :utc_datetime

      add :away_team_id, references(:teams, on_delete: :nothing, type: :uuid)
      add :home_team_id, references(:teams, on_delete: :nothing, type: :uuid)

      timestamps()
    end

    create index(:games, [:away_team_id])
    create index(:games, [:home_team_id])
  end
end

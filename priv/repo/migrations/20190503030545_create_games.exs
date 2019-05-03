defmodule TournamentsApi.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create table(:games, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :home_score, :integer
      add :home_team_name, :string
      add :away_team_name, :string
      add :away_score, :integer
      add :location, :string
      add :datetime, :utc_datetime

      timestamps()
    end
  end
end

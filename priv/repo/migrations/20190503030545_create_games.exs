defmodule TournamentsApi.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create table(:games, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :home_score, :integer
      add :home_team_id, references(:teams, on_delete: :nothing, type: :uuid)
      add :home_team_name, :string
      add :away_score, :integer
      add :away_team_id, references(:teams, on_delete: :nothing, type: :uuid)
      add :away_team_name, :string
      add :location, :string
      add :datetime, :utc_datetime

      timestamps()
    end
  end
end

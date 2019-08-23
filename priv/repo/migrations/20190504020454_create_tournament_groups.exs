defmodule TournamentsApi.Repo.Migrations.CreateTournamentGroups do
  use Ecto.Migration

  def change do
    create table(:tournament_groups, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string

      timestamps()
    end
  end
end

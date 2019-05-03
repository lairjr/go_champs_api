defmodule TournamentsApi.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:teams, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :link, :string
      add :uuid, :uuid

      timestamps()
    end
  end
end

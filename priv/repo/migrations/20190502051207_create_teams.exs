defmodule TournamentsApi.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:teams) do
      add :name, :string
      add :link, :string
      add :uuid, :uuid

      timestamps()
    end
  end
end

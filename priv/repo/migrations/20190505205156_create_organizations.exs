defmodule TournamentsApi.Repo.Migrations.CreateOrganizations do
  use Ecto.Migration

  def change do
    create table(:organizations, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :link, :string

      timestamps()
    end
  end
end

defmodule GoChampsApi.Repo.Migrations.CreateTournaments do
  use Ecto.Migration

  def change do
    create table(:tournaments, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :slug, :string

      timestamps()
    end

    create index(:tournaments, [:slug])
  end
end

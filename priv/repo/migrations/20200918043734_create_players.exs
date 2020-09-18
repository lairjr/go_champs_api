defmodule GoChampsApi.Repo.Migrations.CreatePlayers do
  use Ecto.Migration

  def change do
    create table(:players, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :username, :string
      add :facebook, :string
      add :instagram, :string
      add :twitter, :string

      add :tournament_id, references(:tournaments, on_delete: :nothing, type: :uuid)
      add :team_id, references(:teams, on_delete: :nothing, type: :uuid)

      timestamps()
    end

    create index(:players, [:tournament_id])
  end
end

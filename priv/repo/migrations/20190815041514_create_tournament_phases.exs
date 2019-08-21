defmodule TournamentsApi.Repo.Migrations.CreateTournamentPhases do
  use Ecto.Migration

  def change do
    create table(:tournament_phases, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :title, :string
      add :type, :string
      add :order, :integer
      add :tournament_id, references(:tournaments, on_delete: :nothing, type: :uuid)

      timestamps()
    end

    create index(:tournament_phases, [:tournament_id])
  end
end

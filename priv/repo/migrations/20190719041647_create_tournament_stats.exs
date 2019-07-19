defmodule TournamentsApiWeb.Repo.Migrations.CreateTournamentStats do
  use Ecto.Migration

  def change do
    create table(:tournament_stats, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :title, :string
      add :tournament_id, references(:tournaments, on_delete: :nothing, type: :uuid)

      timestamps()
    end

    create index(:tournament_stats, [:tournament_id])
  end
end

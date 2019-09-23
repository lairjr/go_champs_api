defmodule TournamentsApi.Repo.Migrations.CreatePhaseStandings do
  use Ecto.Migration

  def change do
    create table(:phase_standings, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :title, :string
      add :team_stats, {:array, :map}

      add :tournament_phase_id, references(:tournament_phases, on_delete: :nothing, type: :uuid)

      timestamps()
    end

    create index(:phase_standings, [:tournament_phase_id])
    create unique_index(:phase_standings, [:id, :tournament_phase_id])
  end
end

defmodule TournamentsApi.Repo.Migrations.CreatePhaseRounds do
  use Ecto.Migration

  def change do
    create table(:phase_rounds, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :title, :string
      add :matches, {:array, :map}

      add :tournament_phase_id, references(:tournament_phases, on_delete: :nothing, type: :uuid)

      timestamps()
    end

    create index(:phase_rounds, [:tournament_phase_id])
    create unique_index(:phase_rounds, [:id, :tournament_phase_id])
  end
end

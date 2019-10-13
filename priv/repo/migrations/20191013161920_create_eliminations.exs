defmodule TournamentsApi.Repo.Migrations.CreateEliminations do
  use Ecto.Migration

  def change do
    create table(:eliminations, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :title, :string
      add :team_stats, {:array, :map}

      add :phase_id, references(:phases, on_delete: :nothing, type: :uuid)

      timestamps()
    end

    create index(:eliminations, [:phase_id])
    create unique_index(:eliminations, [:id, :phase_id])
  end
end

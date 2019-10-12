defmodule TournamentsApi.Repo.Migrations.CreatePhaseRounds do
  use Ecto.Migration

  def change do
    create table(:phase_rounds, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :matches, {:array, :map}
      add :order, :integer
      add :title, :string

      add :phase_id, references(:phases, on_delete: :nothing, type: :uuid)

      timestamps()
    end

    create index(:phase_rounds, [:phase_id])
    create unique_index(:phase_rounds, [:id, :phase_id])
  end
end

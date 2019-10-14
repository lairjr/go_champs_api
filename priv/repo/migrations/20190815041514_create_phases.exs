defmodule TournamentsApi.Repo.Migrations.CreatePhases do
  use Ecto.Migration

  def change do
    create table(:phases, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :title, :string
      add :type, :string
      add :order, :integer
      add :elimination_stats, {:array, :map}
      add :tournament_id, references(:tournaments, on_delete: :nothing, type: :uuid)

      timestamps()
    end

    create index(:phases, [:tournament_id])
  end
end

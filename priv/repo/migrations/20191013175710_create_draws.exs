defmodule GoChampsApi.Repo.Migrations.CreateDraws do
  use Ecto.Migration

  def change do
    create table(:draws, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :matches, {:array, :map}
      add :order, :integer
      add :title, :string

      add :phase_id, references(:phases, on_delete: :nothing, type: :uuid)

      timestamps()
    end

    create index(:draws, [:phase_id])
    create unique_index(:draws, [:id, :phase_id])
  end
end

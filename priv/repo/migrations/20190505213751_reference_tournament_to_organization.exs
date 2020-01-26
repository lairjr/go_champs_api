defmodule GoChampsApi.Repo.Migrations.ReferenceTournamentToOrganization do
  use Ecto.Migration

  def change do
    alter table(:tournaments) do
      add :organization_id, references(:organizations, on_delete: :nothing, type: :uuid)
      add :organization_slug, :string
    end

    create index(:tournaments, [:organization_slug])
    create unique_index(:tournaments, [:slug, :organization_id])
  end
end

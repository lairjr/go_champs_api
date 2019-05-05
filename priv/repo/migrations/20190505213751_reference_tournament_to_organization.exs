defmodule TournamentsApi.Repo.Migrations.ReferenceTournamentToOrganization do
  use Ecto.Migration

  def change do
    alter table(:tournaments) do
      add :organization_id, references(:organizations, on_delete: :nothing, type: :uuid)
    end
  end
end

defmodule GoChampsApi.Repo.Migrations.CreateRecentlyView do
  use Ecto.Migration

  def change do
    create table(:recently_view, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :tournament_id, references(:tournaments, on_delete: :nothing, type: :uuid)

      timestamps()
    end
  end
end

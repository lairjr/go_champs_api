defmodule GoChampsApi.Repo.Migrations.AddPlaceholdersAndIsFinishedInGame do
  use Ecto.Migration

  def change do
    alter table(:games) do
      add :away_placeholder, :string
      add :home_placeholder, :string
      add :is_finished, :boolean, default: false
    end
  end
end

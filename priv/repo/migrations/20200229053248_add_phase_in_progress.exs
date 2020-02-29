defmodule GoChampsApi.Repo.Migrations.AddPhaseInProgress do
  use Ecto.Migration

  def change do
    alter table(:phases) do
      add :is_in_progress, :boolean, default: false
    end
  end
end

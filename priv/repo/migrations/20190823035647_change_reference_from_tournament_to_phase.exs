defmodule GoChampsApi.Repo.Migrations.ChangeReferenceFromTournamentToPhase do
  use Ecto.Migration

  def change do
    alter table(:games) do
      add :phase_id, references(:phases, on_delete: :nothing, type: :uuid)
    end

    create index(:games, [:phase_id])
    create unique_index(:games, [:id, :phase_id])
  end
end

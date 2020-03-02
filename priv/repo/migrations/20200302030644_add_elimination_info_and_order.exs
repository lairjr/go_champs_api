defmodule GoChampsApi.Repo.Migrations.AddEliminationInfoAndOrder do
  use Ecto.Migration

  def change do
    alter table(:eliminations) do
      add :info, :string
      add :order, :integer
    end
  end
end

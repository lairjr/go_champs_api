defmodule GoChampsApi.Repo.Migrations.AddTournamentTwitter do
  use Ecto.Migration

  def change do
    alter table(:tournaments) do
      add :twitter, :string
    end
  end
end

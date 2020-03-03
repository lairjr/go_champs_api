defmodule GoChampsApi.Repo.Migrations.AddTournamentSocialLinks do
  use Ecto.Migration

  def change do
    alter table(:tournaments) do
      add :facebook, :string
      add :instagram, :string
      add :site_url, :string
    end
  end
end

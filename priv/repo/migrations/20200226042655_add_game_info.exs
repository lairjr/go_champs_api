defmodule GoChampsApi.Repo.Migrations.AddGameInfo do
  use Ecto.Migration

  def change do
    alter table(:games) do
      add :info, :string
    end
  end
end

defmodule GoChampsApi.Repo.Migrations.AddUsersRecoveryToken do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :recovery_token, :string
    end
  end
end

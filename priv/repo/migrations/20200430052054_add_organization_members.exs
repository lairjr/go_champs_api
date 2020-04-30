defmodule GoChampsApi.Repo.Migrations.AddOrganizationMembers do
  use Ecto.Migration

  def change do
    alter table(:organizations) do
      add :members, {:array, :map}
    end
  end
end

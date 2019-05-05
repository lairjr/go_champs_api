defmodule TournamentsApi.Organizations.Organization do
  use Ecto.Schema
  use TournamentsApi.Schema
  import Ecto.Changeset

  schema "organizations" do
    field :link, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(organization, attrs) do
    organization
    |> cast(attrs, [:name, :link])
    |> validate_required([:name, :link])
  end
end

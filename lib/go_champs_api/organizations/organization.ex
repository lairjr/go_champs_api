defmodule GoChampsApi.Organizations.Organization do
  use Ecto.Schema
  use GoChampsApi.Schema
  import Ecto.Changeset
  alias GoChampsApi.Tournaments.Tournament

  schema "organizations" do
    field :slug, :string
    field :name, :string

    has_many :tournaments, Tournament
    timestamps()
  end

  @doc false
  def changeset(organization, attrs) do
    organization
    |> cast(attrs, [:name, :slug])
    |> validate_required([:name, :slug])
  end
end

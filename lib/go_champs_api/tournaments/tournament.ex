defmodule GoChampsApi.Tournaments.Tournament do
  use Ecto.Schema
  use GoChampsApi.Schema
  import Ecto.Changeset
  alias GoChampsApi.Organizations.Organization
  alias GoChampsApi.Phases.Phase
  alias GoChampsApi.Teams.Team

  schema "tournaments" do
    field :name, :string
    field :slug, :string
    field :organization_slug, :string

    belongs_to :organization, Organization
    has_many :phases, Phase
    has_many :teams, Team

    timestamps()
  end

  @doc false
  def changeset(tournament, attrs) do
    tournament
    |> cast(attrs, [:name, :slug, :organization_id, :organization_slug])
    |> validate_required([:name, :organization_id])
  end
end

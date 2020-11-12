defmodule GoChampsApi.Tournaments.Tournament do
  use Ecto.Schema
  use GoChampsApi.Schema
  import Ecto.Changeset
  alias GoChampsApi.Organizations.Organization
  alias GoChampsApi.Phases.Phase
  alias GoChampsApi.Players.Player
  alias GoChampsApi.Teams.Team

  schema "tournaments" do
    field :name, :string
    field :slug, :string
    field :organization_slug, :string

    field :facebook, :string
    field :instagram, :string
    field :site_url, :string
    field :twitter, :string

    embeds_many :player_stats, PlayerStats, on_replace: :delete do
      field :title, :string
      field :is_default_order, :boolean
    end

    belongs_to :organization, Organization
    has_many :phases, Phase
    has_many :players, Player
    has_many :teams, Team

    timestamps()
  end

  @doc false
  def changeset(tournament, attrs) do
    tournament
    |> cast(attrs, [
      :name,
      :slug,
      :organization_id,
      :facebook,
      :instagram,
      :site_url,
      :twitter,
      :organization_slug
    ])
    |> cast_embed(:player_stats, with: &player_stats_changeset/2)
    |> validate_required([:name, :slug, :organization_id])
    |> validate_format(:slug, ~r/^[a-z0-9]+(?:-[a-z0-9]+)*$/)
    |> unique_constraint(:slug, name: :tournaments_slug_organization_id_index)
  end

  defp player_stats_changeset(schema, params) do
    schema
    |> cast(params, [:title, :is_default_order])
    |> validate_required([:title])
  end
end

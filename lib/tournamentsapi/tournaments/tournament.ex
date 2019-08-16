defmodule TournamentsApi.Tournaments.Tournament do
  use Ecto.Schema
  use TournamentsApi.Schema
  import Ecto.Changeset
  alias TournamentsApi.Organizations.Organization
  alias TournamentsApi.Tournaments.TournamentGame
  alias TournamentsApi.Tournaments.TournamentGroup
  alias TournamentsApi.Tournaments.TournamentPhase
  alias TournamentsApi.Tournaments.TournamentStat
  alias TournamentsApi.Tournaments.TournamentTeam

  schema "tournaments" do
    field :name, :string
    field :slug, :string
    field :organization_slug, :string

    belongs_to :organization, Organization

    has_many :games, TournamentGame
    has_many :groups, TournamentGroup
    has_many :phases, TournamentPhase
    has_many :stats, TournamentStat
    has_many :teams, TournamentTeam

    timestamps()
  end

  @doc false
  def changeset(tournament, attrs) do
    tournament
    |> cast(attrs, [:name, :slug, :organization_id, :organization_slug])
    |> validate_required([:name, :organization_id])
  end
end

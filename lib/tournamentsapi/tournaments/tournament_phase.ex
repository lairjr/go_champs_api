defmodule TournamentsApi.Tournaments.TournamentPhase do
  use Ecto.Schema
  use TournamentsApi.Schema
  import Ecto.Changeset
  alias TournamentsApi.Tournaments.Tournament
  alias TournamentsApi.Tournaments.TournamentGame
  alias TournamentsApi.Tournaments.TournamentGroup
  alias TournamentsApi.Tournaments.TournamentStat

  schema "tournament_phases" do
    field :title, :string
    field :type, :string
    field :order, :integer

    belongs_to :tournament, Tournament
    has_many :games, TournamentGame
    has_many :groups, TournamentGroup
    has_many :stats, TournamentStat

    timestamps()
  end

  @doc false
  def changeset(tournament_phase, attrs) do
    tournament_phase
    |> cast(attrs, [:title, :type, :order, :tournament_id])
    |> validate_required([:title, :type, :tournament_id])
  end
end
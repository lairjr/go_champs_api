defmodule TournamentsApi.Phases.Phase do
  use Ecto.Schema
  use TournamentsApi.Schema
  import Ecto.Changeset
  alias TournamentsApi.Phases.PhaseRound
  alias TournamentsApi.Eliminations.Elimination
  alias TournamentsApi.Tournaments.Tournament
  alias TournamentsApi.Games.Game
  alias TournamentsApi.Tournaments.TournamentStat

  schema "phases" do
    field :title, :string
    field :type, :string
    field :order, :integer

    belongs_to :tournament, Tournament
    has_many :games, Game
    has_many :rounds, PhaseRound
    has_many :stats, TournamentStat
    has_many :eliminations, Elimination

    timestamps()
  end

  @doc false
  def changeset(phase, attrs) do
    phase
    |> cast(attrs, [:title, :type, :order, :tournament_id])
    |> validate_required([:title, :type, :tournament_id])
  end
end

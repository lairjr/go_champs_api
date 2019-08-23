defmodule TournamentsApi.Tournaments.TournamentStat do
  use Ecto.Schema
  use TournamentsApi.Schema
  import Ecto.Changeset
  alias TournamentsApi.Tournaments.TournamentPhase

  schema "tournament_stats" do
    field :title, :string

    belongs_to :tournament_phase, TournamentPhase

    timestamps()
  end

  @doc false
  def changeset(tournament_stat, attrs) do
    tournament_stat
    |> cast(attrs, [:title, :tournament_phase_id])
    |> validate_required([:title, :tournament_phase_id])
  end
end

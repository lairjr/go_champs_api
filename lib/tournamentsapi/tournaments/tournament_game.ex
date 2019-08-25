defmodule TournamentsApi.Tournaments.TournamentGame do
  use Ecto.Schema
  use TournamentsApi.Schema
  import Ecto.Changeset
  alias TournamentsApi.Tournaments.TournamentPhase
  alias TournamentsApi.Tournaments.TournamentTeam

  schema "tournament_games" do
    field :away_score, :integer
    field :datetime, :utc_datetime
    field :home_score, :integer
    field :location, :string

    belongs_to :tournament_phase, TournamentPhase
    belongs_to :away_team, TournamentTeam
    belongs_to :home_team, TournamentTeam

    timestamps()
  end

  @doc false
  def changeset(tournament_game, attrs) do
    tournament_game
    |> cast(attrs, [
      :datetime,
      :location,
      :away_score,
      :home_score,
      :tournament_phase_id,
      :away_team_id,
      :home_team_id
    ])
    |> validate_required([:tournament_phase_id])
  end
end

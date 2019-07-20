defmodule TournamentsApi.Tournaments.TournamentTeamStat do
  use Ecto.Schema
  use TournamentsApi.Schema
  import Ecto.Changeset
  alias TournamentsApi.Tournaments.TournamentTeam

  schema "tournament_team_stats" do
    field :value, :string

    belongs_to :tournament_team, TournamentTeam

    timestamps()
  end

  @doc false
  def changeset(tournament_team_stat, attrs) do
    tournament_team_stat
    |> cast(attrs, [:value, :tournament_team_id])
    |> validate_required([:value, :tournament_team_id])
  end
end

defmodule TournamentsApi.Tournaments.TournamentTeam do
  use Ecto.Schema
  use TournamentsApi.Schema
  import Ecto.Changeset
  alias TournamentsApi.Tournaments.Tournament
  alias TournamentsApi.Tournaments.TournamentGroup

  schema "tournament_teams" do
    field :name, :string
    field :stats, :map

    belongs_to :tournament, Tournament
    belongs_to :tournament_group, TournamentGroup

    timestamps()
  end

  @doc false
  def changeset(tournament_team, attrs) do
    tournament_team
    |> cast(attrs, [:name, :tournament_id, :tournament_group_id, :stats])
    |> validate_required([:name, :tournament_id])
  end
end

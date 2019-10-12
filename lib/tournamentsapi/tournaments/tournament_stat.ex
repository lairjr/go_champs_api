defmodule TournamentsApi.Tournaments.TournamentStat do
  use Ecto.Schema
  use TournamentsApi.Schema
  import Ecto.Changeset
  alias TournamentsApi.Phases.Phase

  schema "tournament_stats" do
    field :title, :string

    belongs_to :phase, Phase

    timestamps()
  end

  @doc false
  def changeset(tournament_stat, attrs) do
    tournament_stat
    |> cast(attrs, [:title, :phase_id])
    |> validate_required([:title, :phase_id])
  end
end

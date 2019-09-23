defmodule TournamentsApi.Phases.PhaseStandings do
  use Ecto.Schema
  use TournamentsApi.Schema
  import Ecto.Changeset
  alias TournamentsApi.Tournaments.TournamentPhase

  schema "phase_standings" do
    field :title, :string

    embeds_many :standings, TeamStandings, on_replace: :delete do
      field :team_id, :binary_id
      field :stats, :map
    end

    belongs_to :tournament_phase, TournamentPhase

    timestamps()
  end

  @doc false
  def changeset(phase_standings, attrs) do
    phase_standings
    |> cast(attrs, [:title, :tournament_phase_id])
    |> cast_embed(:standings, with: &team_standings_changeset/2)
    |> validate_required([:standings, :tournament_phase_id])
  end

  defp team_standings_changeset(schema, params) do
    schema
    |> cast(params, [:team_id, :stats])
  end
end

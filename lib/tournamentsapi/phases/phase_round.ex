defmodule TournamentsApi.Phases.PhaseRound do
  use Ecto.Schema
  use TournamentsApi.Schema
  import Ecto.Changeset
  alias TournamentsApi.Tournaments.TournamentPhase

  schema "phase_rounds" do
    field :title, :string
    field :order, :integer

    embeds_many :matches, RoundMatch, on_replace: :delete do
      field :first_team_id, :binary_id
      field :first_team_parent_id, :binary_id
      field :first_team_placeholder, :string
      field :first_team_score, :string

      field :second_team_id, :binary_id
      field :second_team_parent_id, :binary_id
      field :second_team_placeholder, :string
      field :second_team_score, :string
    end

    belongs_to :tournament_phase, TournamentPhase

    timestamps()
  end

  @doc false
  def changeset(phase_round, attrs) do
    phase_round
    |> cast(attrs, [:order, :title, :tournament_phase_id])
    |> cast_embed(:matches, with: &round_match_changeset/2)
    |> validate_required([:matches, :tournament_phase_id])
  end

  defp round_match_changeset(schema, params) do
    schema
    |> cast(params, [
      :first_team_id,
      :first_team_parent_id,
      :first_team_placeholder,
      :first_team_score,
      :second_team_id,
      :second_team_parent_id,
      :second_team_placeholder,
      :second_team_score
    ])
  end
end

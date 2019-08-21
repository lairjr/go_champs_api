defmodule TournamentsApi.Tournaments.TournamentPhase do
  use Ecto.Schema
  use TournamentsApi.Schema
  import Ecto.Changeset
  alias TournamentsApi.Tournaments.Tournament

  schema "tournament_phases" do
    field :title, :string
    field :type, :string
    field :order, :integer

    belongs_to :tournament, Tournament

    timestamps()
  end

  @doc false
  def changeset(tournament_phase, attrs) do
    tournament_phase
    |> cast(attrs, [:title, :type, :order, :tournament_id])
    |> validate_required([:title, :type, :tournament_id])
  end
end

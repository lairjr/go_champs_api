defmodule TournamentsApi.Teams.Team do
  use Ecto.Schema
  use TournamentsApi.Schema
  import Ecto.Changeset
  alias TournamentsApi.Tournaments.Tournament

  schema "teams" do
    field :name, :string

    belongs_to :tournament, Tournament

    timestamps()
  end

  @doc false
  def changeset(tournament_team, attrs) do
    tournament_team
    |> cast(attrs, [:name, :tournament_id])
    |> validate_required([:name, :tournament_id])
  end
end

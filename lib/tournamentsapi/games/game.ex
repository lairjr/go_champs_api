defmodule TournamentsApi.Games.Game do
  use Ecto.Schema
  use TournamentsApi.Schema
  import Ecto.Changeset
  alias TournamentsApi.Phases.Phase
  alias TournamentsApi.Teams.Team

  schema "games" do
    field :away_score, :integer
    field :datetime, :utc_datetime
    field :home_score, :integer
    field :location, :string

    belongs_to :phase, Phase
    belongs_to :away_team, Team
    belongs_to :home_team, Team

    timestamps()
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [
      :datetime,
      :location,
      :away_score,
      :home_score,
      :phase_id,
      :away_team_id,
      :home_team_id
    ])
    |> validate_required([:phase_id])
  end
end
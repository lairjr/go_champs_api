defmodule GoChampsApi.Games.Game do
  use Ecto.Schema
  use GoChampsApi.Schema
  import Ecto.Changeset
  alias GoChampsApi.Phases.Phase
  alias GoChampsApi.Teams.Team

  schema "games" do
    field :away_score, :integer
    field :datetime, :utc_datetime
    field :home_score, :integer
    field :info, :string
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
      :info,
      :away_team_id,
      :home_team_id
    ])
    |> validate_required([:phase_id])
  end
end

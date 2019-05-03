defmodule TournamentsApi.Games.Game do
  use Ecto.Schema
  import Ecto.Changeset

  schema "games" do
    field :away_score, :integer
    field :away_team_name, :string
    field :datetime, :utc_datetime
    field :home_score, :integer
    field :home_team_name, :string
    field :location, :string

    timestamps()
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [
      :home_score,
      :home_team_name,
      :away_score,
      :away_team_name,
      :location,
      :datetime
    ])
    |> validate_required([:home_score, :away_score, :location, :datetime])
  end
end

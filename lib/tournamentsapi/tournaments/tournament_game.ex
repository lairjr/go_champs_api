defmodule TournamentsApi.Tournaments.TournamentGame do
  use Ecto.Schema
  use TournamentsApi.Schema
  import Ecto.Changeset
  alias TournamentsApi.Tournaments.Tournament
  alias TournamentsApi.Games.Game

  schema "tournament_games" do
    belongs_to :tournament, Tournament
    belongs_to :game, Game

    timestamps()
  end

  @doc false
  def changeset(tournament_game, attrs) do
    tournament_game
    |> cast(attrs, [:tournament_id, :game_id])
    |> validate_required([:tournament_id])
  end
end

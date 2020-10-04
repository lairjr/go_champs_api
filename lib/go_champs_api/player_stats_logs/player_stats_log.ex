defmodule GoChampsApi.PlayerStatsLogs.PlayerStatsLog do
  use Ecto.Schema
  use GoChampsApi.Schema
  import Ecto.Changeset
  alias GoChampsApi.Games.Game
  alias GoChampsApi.Teams.Team
  alias GoChampsApi.Tournaments.Tournament
  alias GoChampsApi.Phases.Phase
  alias GoChampsApi.Players.Player

  schema "player_stats_log" do
    field :stats, :map

    belongs_to :game, Game
    belongs_to :tournament, Tournament
    belongs_to :team, Team
    belongs_to :phase, Phase
    belongs_to :player, Player

    timestamps()
  end

  @doc false
  def changeset(player_stats_log, attrs) do
    player_stats_log
    |> cast(attrs, [
      :stats,
      :game_id,
      :phase_id,
      :player_id,
      :team_id,
      :tournament_id
    ])
    |> validate_required([:stats, :player_id, :tournament_id])
  end
end

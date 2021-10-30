defmodule GoChampsApi.FixedPlayerStatsTables.FixedPlayerStatsTable do
  use Ecto.Schema
  use GoChampsApi.Schema
  import Ecto.Changeset
  alias GoChampsApi.Tournaments.Tournament

  schema "fixed_player_stats_table" do
    field :player_stats, :map
    field :stat_id, :binary_id

    belongs_to :tournament, Tournament

    timestamps()
  end

  @doc false
  def changeset(fixed_player_stats_table, attrs) do
    fixed_player_stats_table
    |> cast(attrs, [
      :player_stats,
      :stat_id,
      :tournament_id
    ])
    |> validate_required([:player_stats, :stat_id, :tournament_id])
  end
end

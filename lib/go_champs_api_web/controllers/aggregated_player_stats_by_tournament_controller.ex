defmodule GoChampsApiWeb.AggregatedPlayerStatsByTournamentController do
  use GoChampsApiWeb, :controller

  alias GoChampsApi.AggregatedPlayerStatsByTournaments

  action_fallback GoChampsApiWeb.FallbackController

  def index(conn, _params) do
    aggregated_player_stats_by_tournament =
      AggregatedPlayerStatsByTournaments.list_aggregated_player_stats_by_tournament()

    render(conn, "index.json",
      aggregated_player_stats_by_tournament: aggregated_player_stats_by_tournament
    )
  end

  def show(conn, %{"id" => id}) do
    aggregated_player_stats_by_tournament =
      AggregatedPlayerStatsByTournaments.get_aggregated_player_stats_by_tournament!(id)

    render(conn, "show.json",
      aggregated_player_stats_by_tournament: aggregated_player_stats_by_tournament
    )
  end
end

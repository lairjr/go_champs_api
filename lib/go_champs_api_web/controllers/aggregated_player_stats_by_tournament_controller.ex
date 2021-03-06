defmodule GoChampsApiWeb.AggregatedPlayerStatsByTournamentController do
  use GoChampsApiWeb, :controller

  alias GoChampsApi.AggregatedPlayerStatsByTournaments
  alias GoChampsApi.Tournaments

  action_fallback GoChampsApiWeb.FallbackController

  defp map_to_keyword(map) do
    Enum.map(map, fn {key, value} -> {String.to_atom(key), value} end)
  end

  def index(conn, params) do
    aggregated_player_stats_by_tournament =
      case params do
        %{"where" => where, "sort" => sort} ->
          where
          |> map_to_keyword()
          |> AggregatedPlayerStatsByTournaments.list_aggregated_player_stats_by_tournament(sort)

        %{"where" => where} ->
          query =
            where
            |> map_to_keyword()

          player_stats_id =
            Tournaments.get_tournament_default_player_stats_order_id!(query[:tournament_id])

          AggregatedPlayerStatsByTournaments.list_aggregated_player_stats_by_tournament(
            query,
            player_stats_id
          )

        _ ->
          AggregatedPlayerStatsByTournaments.list_aggregated_player_stats_by_tournament()
      end

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

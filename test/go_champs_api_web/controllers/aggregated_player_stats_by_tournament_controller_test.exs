defmodule GoChampsApiWeb.AggregatedPlayerStatsByTournamentControllerTest do
  use GoChampsApiWeb.ConnCase

  alias GoChampsApi.Helpers.PlayerHelpers
  alias GoChampsApi.AggregatedPlayerStatsByTournaments

  @create_attrs %{
    stats: %{
      some: "some"
    }
  }

  def fixture(:aggregated_player_stats_by_tournament) do
    attrs = PlayerHelpers.map_player_id_and_tournament_id(@create_attrs)

    {:ok, aggregated_player_stats_by_tournament} =
      AggregatedPlayerStatsByTournaments.create_aggregated_player_stats_by_tournament(attrs)

    aggregated_player_stats_by_tournament
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all aggregated_player_stats_by_tournament", %{conn: conn} do
      conn = get(conn, Routes.v1_aggregated_player_stats_by_tournament_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  defp create_aggregated_player_stats_by_tournament(_) do
    aggregated_player_stats_by_tournament = fixture(:aggregated_player_stats_by_tournament)
    {:ok, aggregated_player_stats_by_tournament: aggregated_player_stats_by_tournament}
  end
end

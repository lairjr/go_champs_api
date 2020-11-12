defmodule GoChampsApiWeb.AggregatedPlayerStatsByTournamentControllerTest do
  use GoChampsApiWeb.ConnCase

  alias GoChampsApi.Helpers.PlayerHelpers
  alias GoChampsApi.AggregatedPlayerStatsByTournaments
  alias GoChampsApi.Tournaments

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

    test "lists all tournaments matching where", %{conn: conn} do
      first_aggregated_player_stats = fixture(:aggregated_player_stats_by_tournament)

      tournament = Tournaments.get_tournament!(first_aggregated_player_stats.tournament_id)

      {:ok, other_tournament} =
        %{name: "some other tournament", slug: "some-other-tournament"}
        |> Map.merge(%{organization_id: tournament.organization_id})
        |> Tournaments.create_tournament()

      {:ok, second_aggregated_player_stats} =
        @create_attrs
        |> Map.merge(%{
          tournament_id: other_tournament.id,
          player_id: first_aggregated_player_stats.player_id
        })
        |> AggregatedPlayerStatsByTournaments.create_aggregated_player_stats_by_tournament()

      where = %{"tournament_id" => second_aggregated_player_stats.tournament_id}

      conn =
        get(
          conn,
          Routes.v1_aggregated_player_stats_by_tournament_path(conn, :index, where: where)
        )

      [aggregated_player_stats_result] = json_response(conn, 200)["data"]
      assert aggregated_player_stats_result["id"] == second_aggregated_player_stats.id
    end
  end
end

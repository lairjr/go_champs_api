defmodule GoChampsApiWeb.TeamStatsLogControllerTest do
  use GoChampsApiWeb.ConnCase

  alias GoChampsApi.TeamStatsLogs
  alias GoChampsApi.TeamStatsLogs.TeamStatsLog
  alias GoChampsApi.Helpers.TeamHelpers
  alias GoChampsApi.Helpers.PhaseHelpers

  @create_attrs %{
    stats: %{
      some: "some"
    }
  }
  @update_attrs %{
    stats: %{
      some: "some updated"
    }
  }
  @invalid_attrs %{datetime: nil, stats: nil}

  def fixture(:team_stats_log) do
    {:ok, team_stats_log} =
      @create_attrs
      |> TeamHelpers.map_team_id_and_tournament_id()
      |> PhaseHelpers.map_phase_id_for_tournament()
      |> TeamStatsLogs.create_team_stats_log()

    team_stats_log
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all team_stats_log", %{conn: conn} do
      conn = get(conn, Routes.v1_team_stats_log_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create team_stats_log" do
    @tag :authenticated
    test "renders team_stats_log when data is valid", %{conn: conn} do
      create_attrs =
        @create_attrs
        |> TeamHelpers.map_team_id_and_tournament_id()
        |> PhaseHelpers.map_phase_id_for_tournament()

      conn =
        post(conn, Routes.v1_team_stats_log_path(conn, :create), team_stats_log: create_attrs)

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.v1_team_stats_log_path(conn, :show, id))

      assert %{
               "id" => id,
               "stats" => %{}
             } = json_response(conn, 200)["data"]
    end

    @tag :authenticated
    test "renders errors when data is invalid", %{conn: conn} do
      conn =
        post(conn, Routes.v1_team_stats_log_path(conn, :create), team_stats_log: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update team_stats_log" do
    setup [:create_team_stats_log]

    @tag :authenticated
    test "renders team_stats_log when data is valid", %{
      conn: conn,
      team_stats_log: %TeamStatsLog{id: id} = team_stats_log
    } do
      conn =
        put(conn, Routes.v1_team_stats_log_path(conn, :update, team_stats_log),
          team_stats_log: @update_attrs
        )

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.v1_team_stats_log_path(conn, :show, id))

      assert %{
               "id" => id,
               "stats" => %{}
             } = json_response(conn, 200)["data"]
    end

    @tag :authenticated
    test "renders errors when data is invalid", %{conn: conn, team_stats_log: team_stats_log} do
      conn =
        put(conn, Routes.v1_team_stats_log_path(conn, :update, team_stats_log),
          team_stats_log: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete team_stats_log" do
    setup [:create_team_stats_log]

    @tag :authenticated
    test "deletes chosen team_stats_log", %{conn: conn, team_stats_log: team_stats_log} do
      conn = delete(conn, Routes.v1_team_stats_log_path(conn, :delete, team_stats_log))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.v1_team_stats_log_path(conn, :show, team_stats_log))
      end
    end
  end

  defp create_team_stats_log(_) do
    team_stats_log = fixture(:team_stats_log)
    %{team_stats_log: team_stats_log}
  end
end

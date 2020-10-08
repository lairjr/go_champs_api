defmodule GoChampsApiWeb.PlayerStatsLogControllerTest do
  use GoChampsApiWeb.ConnCase

  alias GoChampsApi.PlayerStatsLogs
  alias GoChampsApi.PlayerStatsLogs.PlayerStatsLog
  alias GoChampsApi.Helpers.PlayerHelpers

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
  @invalid_attrs %{stats: nil}

  def fixture(:player_stats_log) do
    attrs = PlayerHelpers.map_player_id_and_tournament_id(@create_attrs)
    {:ok, player_stats_log} = PlayerStatsLogs.create_player_stats_log(attrs)
    player_stats_log
  end

  def fixture(:player_stats_log_with_different_member) do
    attrs = PlayerHelpers.map_player_id_and_tournament_id_with_other_member(@create_attrs)
    {:ok, player_stats_log} = PlayerStatsLogs.create_player_stats_log(attrs)
    player_stats_log
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all player_stats_log", %{conn: conn} do
      conn = get(conn, Routes.v1_player_stats_log_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create player_stats_log" do
    @tag :authenticated
    test "renders player_stats_log when data is valid", %{conn: conn} do
      create_attrs = PlayerHelpers.map_player_id_and_tournament_id(@create_attrs)

      conn =
        post(conn, Routes.v1_player_stats_log_path(conn, :create), player_stats_log: create_attrs)

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.v1_player_stats_log_path(conn, :show, id))

      assert %{
               "id" => id,
               "stats" => %{
                 "some" => "some"
               }
             } = json_response(conn, 200)["data"]
    end

    @tag :authenticated
    test "renders errors when data is invalid", %{conn: conn} do
      invalid_attrs = PlayerHelpers.map_player_id_and_tournament_id(@invalid_attrs)

      conn =
        post(conn, Routes.v1_player_stats_log_path(conn, :create), player_stats_log: invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update player_stats_log" do
    setup [:create_player_stats_log]

    @tag :authenticated
    test "renders player_stats_log when data is valid", %{
      conn: conn,
      player_stats_log: %PlayerStatsLog{id: id} = player_stats_log
    } do
      conn =
        put(conn, Routes.v1_player_stats_log_path(conn, :update, player_stats_log),
          player_stats_log: @update_attrs
        )

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.v1_player_stats_log_path(conn, :show, id))

      assert %{
               "id" => id,
               "stats" => %{
                 "some" => "some updated"
               }
             } = json_response(conn, 200)["data"]
    end

    @tag :authenticated
    test "renders errors when data is invalid", %{conn: conn, player_stats_log: player_stats_log} do
      conn =
        put(conn, Routes.v1_player_stats_log_path(conn, :update, player_stats_log),
          player_stats_log: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "batch update player_stats_log" do
    setup %{conn: conn} do
      first_player_stats_log = fixture(:player_stats_log)

      attrs =
        Map.merge(@create_attrs, %{
          player_id: first_player_stats_log.player_id,
          tournament_id: first_player_stats_log.tournament_id
        })

      {:ok, second_player_stats_log} = PlayerStatsLogs.create_player_stats_log(attrs)
      {:ok, conn: conn, player_stats_logs: [first_player_stats_log, second_player_stats_log]}
    end

    @tag :authenticated
    test "renders player_stats_logs when data is valid", %{
      conn: conn,
      player_stats_logs: [first_player_stats_log, second_player_stats_log]
    } do
      first_player_stats_log_update =
        Map.merge(
          %{id: first_player_stats_log.id},
          %{stats: %{"some" => "some first updated"}}
        )

      second_player_stats_log_update =
        Map.merge(
          %{id: second_player_stats_log.id},
          %{stats: %{"some" => "some second updated"}}
        )

      player_stats_logs = [first_player_stats_log_update, second_player_stats_log_update]

      conn =
        patch(
          conn,
          Routes.v1_player_stats_log_path(
            conn,
            :batch_update
          ),
          player_stats_logs: player_stats_logs
        )

      first_player_stats_log_id = first_player_stats_log.id
      second_player_stats_log_id = second_player_stats_log.id

      %{
        ^first_player_stats_log_id => first_player_stats_log_result,
        ^second_player_stats_log_id => second_player_stats_log_result
      } = json_response(conn, 200)["data"]

      assert first_player_stats_log_result["id"] == first_player_stats_log.id

      assert first_player_stats_log_result["stats"] == %{
               "some" => "some first updated"
             }

      assert second_player_stats_log_result["id"] == second_player_stats_log.id

      assert second_player_stats_log_result["stats"] == %{
               "some" => "some second updated"
             }
    end
  end

  describe "delete player_stats_log" do
    setup [:create_player_stats_log]

    @tag :authenticated
    test "deletes chosen player_stats_log", %{conn: conn, player_stats_log: player_stats_log} do
      conn = delete(conn, Routes.v1_player_stats_log_path(conn, :delete, player_stats_log))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.v1_player_stats_log_path(conn, :show, player_stats_log))
      end
    end
  end

  defp create_player_stats_log(_) do
    player_stats_log = fixture(:player_stats_log)
    {:ok, player_stats_log: player_stats_log}
  end
end

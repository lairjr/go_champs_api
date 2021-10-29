defmodule GoChampsApiWeb.FixedPlayerStatsTableControllerTest do
  use GoChampsApiWeb.ConnCase

  alias GoChampsApi.FixedPlayerStatsTables
  alias GoChampsApi.FixedPlayerStatsTables.FixedPlayerStatsTable

  @create_attrs %{
    player_stats: %{}
  }
  @update_attrs %{
    player_stats: %{}
  }
  @invalid_attrs %{player_stats: nil}

  def fixture(:fixed_player_stats_table) do
    {:ok, fixed_player_stats_table} =
      FixedPlayerStatsTables.create_fixed_player_stats_table(@create_attrs)

    fixed_player_stats_table
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all fixed_player_stats_table", %{conn: conn} do
      conn = get(conn, Routes.fixed_player_stats_table_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create fixed_player_stats_table" do
    test "renders fixed_player_stats_table when data is valid", %{conn: conn} do
      conn =
        post(conn, Routes.fixed_player_stats_table_path(conn, :create),
          fixed_player_stats_table: @create_attrs
        )

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.fixed_player_stats_table_path(conn, :show, id))

      assert %{
               "id" => id,
               "player_stats" => %{}
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn =
        post(conn, Routes.fixed_player_stats_table_path(conn, :create),
          fixed_player_stats_table: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update fixed_player_stats_table" do
    setup [:create_fixed_player_stats_table]

    test "renders fixed_player_stats_table when data is valid", %{
      conn: conn,
      fixed_player_stats_table: %FixedPlayerStatsTable{id: id} = fixed_player_stats_table
    } do
      conn =
        put(conn, Routes.fixed_player_stats_table_path(conn, :update, fixed_player_stats_table),
          fixed_player_stats_table: @update_attrs
        )

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.fixed_player_stats_table_path(conn, :show, id))

      assert %{
               "id" => id,
               "player_stats" => %{}
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{
      conn: conn,
      fixed_player_stats_table: fixed_player_stats_table
    } do
      conn =
        put(conn, Routes.fixed_player_stats_table_path(conn, :update, fixed_player_stats_table),
          fixed_player_stats_table: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete fixed_player_stats_table" do
    setup [:create_fixed_player_stats_table]

    test "deletes chosen fixed_player_stats_table", %{
      conn: conn,
      fixed_player_stats_table: fixed_player_stats_table
    } do
      conn =
        delete(
          conn,
          Routes.fixed_player_stats_table_path(conn, :delete, fixed_player_stats_table)
        )

      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.fixed_player_stats_table_path(conn, :show, fixed_player_stats_table))
      end
    end
  end

  defp create_fixed_player_stats_table(_) do
    fixed_player_stats_table = fixture(:fixed_player_stats_table)
    %{fixed_player_stats_table: fixed_player_stats_table}
  end
end

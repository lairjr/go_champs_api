defmodule GoChampsApiWeb.FixedPlayerStatsTableControllerTest do
  use GoChampsApiWeb.ConnCase

  alias GoChampsApi.FixedPlayerStatsTables
  alias GoChampsApi.FixedPlayerStatsTables.FixedPlayerStatsTable
  alias GoChampsApi.Helpers.TournamentHelpers
  alias GoChampsApi.Tournaments

  @create_attrs %{
    player_stats: [
      %{
        player_id: "some-id",
        value: "10"
      }
    ]
  }
  @update_attrs %{
    player_stats: [
      %{
        player_id: "some-id",
        value: "11"
      }
    ]
  }
  @invalid_attrs %{player_stats: nil}

  def fixture(:fixed_player_stats_table) do
    attrs = TournamentHelpers.map_tournament_id_and_stat_id(@create_attrs)

    {:ok, fixed_player_stats_table} =
      FixedPlayerStatsTables.create_fixed_player_stats_table(attrs)

    fixed_player_stats_table
  end

  def fixture(:fixed_player_stats_table_with_different_member) do
    attrs = TournamentHelpers.map_tournament_id_and_stat_id_with_other_member(@create_attrs)

    {:ok, fixed_player_stats_table} =
      FixedPlayerStatsTables.create_fixed_player_stats_table(attrs)

    fixed_player_stats_table
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all fixed_player_stats_table matching where", %{conn: conn} do
      first_fixed_player_stats_table = fixture(:fixed_player_stats_table)

      tournament = Tournaments.get_tournament!(first_fixed_player_stats_table.tournament_id)

      {:ok, another_tournament} =
        %{
          name: "another tournament",
          slug: "another-slug",
          player_stats: [
            %{
              title: "some stat"
            }
          ]
        }
        |> Map.merge(%{organization_id: tournament.organization_id})
        |> Tournaments.create_tournament()

      [second_player_stat] = another_tournament.player_stats

      {:ok, second_fixed_player_stats_table} =
        @create_attrs
        |> Map.merge(%{tournament_id: another_tournament.id, stat_id: second_player_stat.id})
        |> FixedPlayerStatsTables.create_fixed_player_stats_table()

      where = %{"tournament_id" => second_fixed_player_stats_table.tournament_id}

      conn = get(conn, Routes.v1_fixed_player_stats_table_path(conn, :index, where: where))
      [fixed_player_stats_table_result] = json_response(conn, 200)["data"]
      assert fixed_player_stats_table_result["id"] == second_fixed_player_stats_table.id
    end
  end

  describe "create fixed_player_stats_table" do
    @tag :authenticated
    test "renders fixed_player_stats_table when data is valid", %{conn: conn} do
      attrs = TournamentHelpers.map_tournament_id_and_stat_id(@create_attrs)
      stat_id = attrs.stat_id

      conn =
        post(conn, Routes.v1_fixed_player_stats_table_path(conn, :create),
          fixed_player_stats_table: attrs
        )

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.v1_fixed_player_stats_table_path(conn, :show, id))

      %{
        "id" => response_id,
        "stat_id" => response_stat_id,
        "player_stats" => [response_player_stats]
      } = json_response(conn, 200)["data"]

      assert response_id == id
      assert response_stat_id == stat_id
      assert response_player_stats["player_id"] == "some-id"
      assert response_player_stats["value"] == "10"
    end

    @tag :authenticated
    test "renders errors when data is invalid", %{conn: conn} do
      attrs = TournamentHelpers.map_tournament_id_and_stat_id(@invalid_attrs)

      conn =
        post(conn, Routes.v1_fixed_player_stats_table_path(conn, :create),
          fixed_player_stats_table: attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "create fixed_player_stats_table with different organization member" do
    @tag :authenticated
    test "returns forbidden for an user that is not a member", %{conn: conn} do
      attrs = TournamentHelpers.map_tournament_id_with_other_member(@create_attrs)

      conn =
        post(conn, Routes.v1_fixed_player_stats_table_path(conn, :create),
          fixed_player_stats_table: attrs
        )

      assert text_response(conn, 403) == "Forbidden"
    end
  end

  describe "update fixed_player_stats_table" do
    setup [:create_fixed_player_stats_table]

    @tag :authenticated
    test "renders fixed_player_stats_table when data is valid", %{
      conn: conn,
      fixed_player_stats_table:
        %FixedPlayerStatsTable{id: id, stat_id: stat_id} = fixed_player_stats_table
    } do
      conn =
        put(
          conn,
          Routes.v1_fixed_player_stats_table_path(conn, :update, fixed_player_stats_table),
          fixed_player_stats_table: @update_attrs
        )

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.v1_fixed_player_stats_table_path(conn, :show, id))

      %{
        "id" => response_id,
        "stat_id" => response_stat_id,
        "player_stats" => [response_player_stats]
      } = json_response(conn, 200)["data"]

      assert response_id == id
      assert response_stat_id == stat_id
      assert response_player_stats["player_id"] == "some-id"
      assert response_player_stats["value"] == "11"
    end

    @tag :authenticated
    test "renders errors when data is invalid", %{
      conn: conn,
      fixed_player_stats_table: fixed_player_stats_table
    } do
      conn =
        put(
          conn,
          Routes.v1_fixed_player_stats_table_path(conn, :update, fixed_player_stats_table),
          fixed_player_stats_table: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update fixed_player_stats_table with different member" do
    setup [:create_fixed_player_stats_table_with_different_member]

    @tag :authenticated
    test "returns forbidden for an user that is not a member", %{
      conn: conn,
      fixed_player_stats_table: fixed_player_stats_table
    } do
      conn =
        put(
          conn,
          Routes.v1_fixed_player_stats_table_path(
            conn,
            :update,
            fixed_player_stats_table
          ),
          fixed_player_stats_table: @update_attrs
        )

      assert text_response(conn, 403) == "Forbidden"
    end
  end

  describe "delete fixed_player_stats_table" do
    setup [:create_fixed_player_stats_table]

    @tag :authenticated
    test "deletes chosen fixed_player_stats_table", %{
      conn: conn,
      fixed_player_stats_table: fixed_player_stats_table
    } do
      conn =
        delete(
          conn,
          Routes.v1_fixed_player_stats_table_path(conn, :delete, fixed_player_stats_table)
        )

      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.v1_fixed_player_stats_table_path(conn, :show, fixed_player_stats_table))
      end
    end
  end

  describe "delete fixed_player_stats_table with different member" do
    setup [:create_fixed_player_stats_table_with_different_member]

    @tag :authenticated
    test "returns forbidden for an user that is not a member", %{
      conn: conn,
      fixed_player_stats_table: fixed_player_stats_table
    } do
      conn =
        delete(
          conn,
          Routes.v1_fixed_player_stats_table_path(
            conn,
            :delete,
            fixed_player_stats_table
          )
        )

      assert text_response(conn, 403) == "Forbidden"
    end
  end

  defp create_fixed_player_stats_table(_) do
    fixed_player_stats_table = fixture(:fixed_player_stats_table)
    %{fixed_player_stats_table: fixed_player_stats_table}
  end

  defp create_fixed_player_stats_table_with_different_member(_) do
    fixed_player_stats_table = fixture(:fixed_player_stats_table_with_different_member)
    {:ok, fixed_player_stats_table: fixed_player_stats_table}
  end
end

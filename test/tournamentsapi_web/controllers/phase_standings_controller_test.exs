defmodule TournamentsApiWeb.PhaseStandingsControllerTest do
  use TournamentsApiWeb.ConnCase

  alias TournamentsApi.Helpers.PhaseHelpers
  alias TournamentsApi.Phases
  alias TournamentsApi.Phases.PhaseStandings

  random_uuid = "d6a40c15-7363-4179-9f7b-8b17cc6cf32c"
  @create_attrs %{team_stats: [%{team_id: random_uuid, stats: %{"key" => "value"}}]}
  @update_attrs %{team_stats: [%{team_id: random_uuid, stats: %{"key" => "updated"}}]}
  @invalid_attrs %{team_stats: nil}

  def fixture(:phase_standings) do
    phase_standings_attrs = PhaseHelpers.map_phase_id(@create_attrs)
    {:ok, phase_standings} = Phases.create_phase_standings(phase_standings_attrs)
    phase_standings
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all phase_standings", %{conn: conn} do
      conn =
        get(
          conn,
          Routes.phase_standings_path(conn, :index, "d6a40c15-7363-4179-9f7b-8b17cc6cf32c")
        )

      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create phase_standings" do
    test "renders phase_standings when data is valid", %{conn: conn} do
      attrs = PhaseHelpers.map_phase_id(@create_attrs)

      conn =
        post(conn, Routes.phase_standings_path(conn, :create, attrs.phase_id),
          phase_standings: attrs
        )

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.phase_standings_path(conn, :show, attrs.phase_id, id))

      %{"id" => result_id, "team_stats" => [team_stat]} = json_response(conn, 200)["data"]

      assert result_id == id
      assert team_stat["stats"] == %{"key" => "value"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      attrs = PhaseHelpers.map_phase_id(@invalid_attrs)

      conn =
        post(conn, Routes.phase_standings_path(conn, :create, attrs.phase_id),
          phase_standings: attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update phase_standings" do
    setup [:create_phase_standings]

    test "renders phase_standings when data is valid", %{
      conn: conn,
      phase_standings: %PhaseStandings{id: id, phase_id: phase_id} = phase_standings
    } do
      conn =
        put(
          conn,
          Routes.phase_standings_path(conn, :update, phase_id, phase_standings),
          phase_standings: @update_attrs
        )

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.phase_standings_path(conn, :show, phase_id, id))

      %{"id" => result_id, "team_stats" => [team_stat]} = json_response(conn, 200)["data"]

      assert result_id == id
      assert team_stat["stats"] == %{"key" => "updated"}
    end

    test "renders errors when data is invalid", %{conn: conn, phase_standings: phase_standings} do
      conn =
        put(
          conn,
          Routes.phase_standings_path(
            conn,
            :update,
            phase_standings.phase_id,
            phase_standings
          ),
          phase_standings: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete phase_standings" do
    setup [:create_phase_standings]

    test "deletes chosen phase_standings", %{conn: conn, phase_standings: phase_standings} do
      conn =
        delete(
          conn,
          Routes.phase_standings_path(
            conn,
            :delete,
            phase_standings.phase_id,
            phase_standings
          )
        )

      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(
          conn,
          Routes.phase_standings_path(
            conn,
            :show,
            phase_standings.phase_id,
            phase_standings
          )
        )
      end
    end
  end

  defp create_phase_standings(_) do
    phase_standings = fixture(:phase_standings)
    {:ok, phase_standings: phase_standings}
  end
end

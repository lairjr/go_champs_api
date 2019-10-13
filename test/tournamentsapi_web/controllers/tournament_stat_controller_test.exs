defmodule TournamentsApiWeb.TournamentStatControllerTest do
  use TournamentsApiWeb.ConnCase

  alias TournamentsApi.Helpers.PhaseHelpers
  alias TournamentsApi.Tournaments
  alias TournamentsApi.Tournaments.TournamentStat

  @create_attrs %{
    title: "some title"
  }
  @update_attrs %{
    title: "some updated title"
  }
  @invalid_attrs %{title: nil}

  def fixture(:tournament_stat) do
    attrs = PhaseHelpers.map_phase_id(@create_attrs)
    {:ok, tournament_stat} = Tournaments.create_tournament_stat(attrs)
    tournament_stat
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all tournament_stats", %{conn: conn} do
      random_uuid = "d6a40c15-7363-4179-9f7b-8b17cc6cf32c"
      conn = get(conn, Routes.tournament_stat_path(conn, :index, random_uuid))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create tournament_stat" do
    test "renders tournament_stat when data is valid", %{conn: conn} do
      attrs = PhaseHelpers.map_phase_id(@create_attrs)

      conn =
        post(conn, Routes.tournament_stat_path(conn, :create, attrs.phase_id),
          tournament_stat: attrs
        )

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.tournament_stat_path(conn, :show, attrs.phase_id, id))

      assert %{
               "id" => id,
               "title" => "some title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      attrs = PhaseHelpers.map_phase_id(@invalid_attrs)

      conn =
        post(conn, Routes.tournament_stat_path(conn, :create, attrs.phase_id),
          tournament_stat: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update tournament_stat" do
    setup [:create_tournament_stat]

    test "renders tournament_stat when data is valid", %{
      conn: conn,
      tournament_stat: %TournamentStat{id: id, phase_id: phase_id} = tournament_stat
    } do
      conn =
        put(
          conn,
          Routes.tournament_stat_path(conn, :update, phase_id, tournament_stat),
          tournament_stat: @update_attrs
        )

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.tournament_stat_path(conn, :show, phase_id, id))

      assert %{
               "id" => id,
               "title" => "some updated title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, tournament_stat: tournament_stat} do
      conn =
        put(
          conn,
          Routes.tournament_stat_path(
            conn,
            :update,
            tournament_stat.phase_id,
            tournament_stat
          ),
          tournament_stat: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete tournament_stat" do
    setup [:create_tournament_stat]

    test "deletes chosen tournament_stat", %{conn: conn, tournament_stat: tournament_stat} do
      conn =
        delete(
          conn,
          Routes.tournament_stat_path(
            conn,
            :delete,
            tournament_stat.phase_id,
            tournament_stat
          )
        )

      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(
          conn,
          Routes.tournament_stat_path(
            conn,
            :show,
            tournament_stat.phase_id,
            tournament_stat
          )
        )
      end
    end
  end

  defp create_tournament_stat(_) do
    tournament_stat = fixture(:tournament_stat)
    {:ok, tournament_stat: tournament_stat}
  end
end

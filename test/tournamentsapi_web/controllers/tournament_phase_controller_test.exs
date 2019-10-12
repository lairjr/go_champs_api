defmodule TournamentsApiWeb.TournamentPhaseControllerTest do
  use TournamentsApiWeb.ConnCase

  alias TournamentsApi.Helpers.TournamentHelpers
  alias TournamentsApi.Tournaments
  alias TournamentsApi.Tournaments.TournamentPhase

  @create_attrs %{
    title: "some title",
    type: "standings"
  }
  @update_attrs %{
    title: "some updated title",
    type: "standings"
  }
  @invalid_attrs %{title: nil, type: nil}

  def fixture(:tournament_phase) do
    attrs = TournamentHelpers.map_tournament_id(@create_attrs)
    {:ok, tournament_phase} = Tournaments.create_tournament_phase(attrs)
    tournament_phase
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all tournament_phases", %{conn: conn} do
      random_uuid = "d6a40c15-7363-4179-9f7b-8b17cc6cf32c"
      conn = get(conn, Routes.tournament_phase_path(conn, :index, random_uuid))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create tournament_phase" do
    test "renders tournament_phase when data is valid", %{conn: conn} do
      attrs = TournamentHelpers.map_tournament_id(@create_attrs)

      conn =
        post(conn, Routes.tournament_phase_path(conn, :create, attrs.tournament_id),
          tournament_phase: attrs
        )

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.tournament_phase_path(conn, :show, attrs.tournament_id, id))

      assert %{
               "id" => id,
               "title" => "some title",
               "type" => "standings"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      attrs = TournamentHelpers.map_tournament_id(@invalid_attrs)

      conn =
        post(conn, Routes.tournament_phase_path(conn, :create, attrs.tournament_id),
          tournament_phase: attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update tournament_phase" do
    setup [:create_tournament_phase]

    test "renders tournament_phase when data is valid", %{
      conn: conn,
      tournament_phase: %TournamentPhase{id: id} = tournament_phase
    } do
      conn =
        put(
          conn,
          Routes.tournament_phase_path(
            conn,
            :update,
            tournament_phase.tournament_id,
            tournament_phase
          ),
          tournament_phase: @update_attrs
        )

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn =
        get(conn, Routes.tournament_phase_path(conn, :show, tournament_phase.tournament_id, id))

      assert %{
               "id" => id,
               "title" => "some updated title",
               "type" => "standings"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, tournament_phase: tournament_phase} do
      conn =
        put(
          conn,
          Routes.tournament_phase_path(
            conn,
            :update,
            tournament_phase.tournament_id,
            tournament_phase
          ),
          tournament_phase: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete tournament_phase" do
    setup [:create_tournament_phase]

    test "deletes chosen tournament_phase", %{conn: conn, tournament_phase: tournament_phase} do
      conn =
        delete(
          conn,
          Routes.tournament_phase_path(
            conn,
            :delete,
            tournament_phase.tournament_id,
            tournament_phase
          )
        )

      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(
          conn,
          Routes.tournament_phase_path(
            conn,
            :show,
            tournament_phase.tournament_id,
            tournament_phase
          )
        )
      end
    end
  end

  defp create_tournament_phase(_) do
    tournament_phase = fixture(:tournament_phase)
    {:ok, tournament_phase: tournament_phase}
  end
end

defmodule TournamentsApiWeb.PhaseRoundControllerTest do
  use TournamentsApiWeb.ConnCase

  alias TournamentsApi.Organizations
  alias TournamentsApi.Phases
  alias TournamentsApi.Phases.PhaseRound
  alias TournamentsApi.Tournaments

  @create_attrs %{
    title: "some title",
    matches: [
      %{
        first_team_placeholder: "some-first-team-placeholder",
        second_team_placeholder: "some-second-team-placeholder"
      }
    ]
  }
  @update_attrs %{
    title: "some updated title",
    matches: [
      %{
        first_team_placeholder: "some-updated-first-team-placeholder",
        second_team_placeholder: "some-updated-second-team-placeholder"
      }
    ]
  }
  @invalid_attrs %{title: nil, matches: nil}

  def map_tournament_phase_id(attrs \\ %{}) do
    {:ok, organization} =
      Organizations.create_organization(%{name: "some organization", slug: "some-slug"})

    tournament_attrs = Map.merge(%{name: "some tournament"}, %{organization_id: organization.id})

    {:ok, tournament} = Tournaments.create_tournament(tournament_attrs)

    tournament_phase_attrs =
      Map.merge(%{title: "some phase", type: "stadings"}, %{tournament_id: tournament.id})

    {:ok, tournament_phase} = Tournaments.create_tournament_phase(tournament_phase_attrs)

    Map.merge(attrs, %{tournament_phase_id: tournament_phase.id})
  end

  def fixture(:phase_round) do
    phase_round_attrs = map_tournament_phase_id(@create_attrs)
    {:ok, phase_round} = Phases.create_phase_round(phase_round_attrs)
    phase_round
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all phase_rounds", %{conn: conn} do
      conn =
        get(conn, Routes.phase_round_path(conn, :index, "d6a40c15-7363-4179-9f7b-8b17cc6cf32c"))

      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create phase_round" do
    test "renders phase_round when data is valid", %{conn: conn} do
      attrs = map_tournament_phase_id(@create_attrs)

      conn =
        post(conn, Routes.phase_round_path(conn, :create, attrs.tournament_phase_id),
          phase_round: attrs
        )

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.phase_round_path(conn, :show, attrs.tournament_phase_id, id))

      assert %{
               "id" => id,
               "title" => "some title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      attrs = map_tournament_phase_id(@invalid_attrs)

      conn =
        post(conn, Routes.phase_round_path(conn, :create, attrs.tournament_phase_id),
          phase_round: attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update phase_round" do
    setup [:create_phase_round]

    test "renders phase_round when data is valid", %{
      conn: conn,
      phase_round: %PhaseRound{id: id, tournament_phase_id: tournament_phase_id} = phase_round
    } do
      conn =
        put(conn, Routes.phase_round_path(conn, :update, tournament_phase_id, phase_round),
          phase_round: @update_attrs
        )

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.phase_round_path(conn, :show, tournament_phase_id, id))

      assert %{
               "id" => id,
               "title" => "some updated title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, phase_round: phase_round} do
      conn =
        put(
          conn,
          Routes.phase_round_path(conn, :update, phase_round.tournament_phase_id, phase_round),
          phase_round: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete phase_round" do
    setup [:create_phase_round]

    test "deletes chosen phase_round", %{conn: conn, phase_round: phase_round} do
      conn =
        delete(
          conn,
          Routes.phase_round_path(conn, :delete, phase_round.tournament_phase_id, phase_round)
        )

      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(
          conn,
          Routes.phase_round_path(conn, :show, phase_round.tournament_phase_id, phase_round)
        )
      end
    end
  end

  defp create_phase_round(_) do
    phase_round = fixture(:phase_round)
    {:ok, phase_round: phase_round}
  end
end

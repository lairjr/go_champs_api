defmodule TournamentsApiWeb.TournamentPhaseController do
  use TournamentsApiWeb, :controller

  alias TournamentsApi.Tournaments
  alias TournamentsApi.Tournaments.TournamentPhase

  action_fallback TournamentsApiWeb.FallbackController

  def index(conn, %{"tournament_id" => tournament_id}) do
    tournament_phases = Tournaments.list_tournament_phases(tournament_id)
    render(conn, "index.json", tournament_phases: tournament_phases)
  end

  def create(conn, %{
        "tournament_phase" => tournament_phase_params,
        "tournament_id" => tournament_id
      }) do
    tournament_phase_params =
      Map.merge(tournament_phase_params, %{"tournament_id" => tournament_id})

    with {:ok, %TournamentPhase{} = tournament_phase} <-
           Tournaments.create_tournament_phase(tournament_phase_params) do
      conn
      |> put_status(:created)
      |> put_resp_header(
        "location",
        Routes.tournament_phase_path(conn, :show, tournament_id, tournament_phase)
      )
      |> render("show.json", tournament_phase: tournament_phase)
    end
  end

  def show(conn, %{"id" => id, "tournament_id" => tournament_id}) do
    tournament_phase = Tournaments.get_tournament_phase!(id, tournament_id)
    render(conn, "show.json", tournament_phase: tournament_phase)
  end

  def update(conn, %{
        "id" => id,
        "tournament_phase" => tournament_phase_params,
        "tournament_id" => tournament_id
      }) do
    tournament_phase = Tournaments.get_tournament_phase!(id, tournament_id)

    with {:ok, %TournamentPhase{} = tournament_phase} <-
           Tournaments.update_tournament_phase(tournament_phase, tournament_phase_params) do
      render(conn, "show.json", tournament_phase: tournament_phase)
    end
  end

  def delete(conn, %{"id" => id, "tournament_id" => tournament_id}) do
    tournament_phase = Tournaments.get_tournament_phase!(id, tournament_id)

    with {:ok, %TournamentPhase{}} <- Tournaments.delete_tournament_phase(tournament_phase) do
      send_resp(conn, :no_content, "")
    end
  end
end

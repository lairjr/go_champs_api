defmodule TournamentsApiWeb.PhaseStandingsController do
  use TournamentsApiWeb, :controller

  alias TournamentsApi.Phases
  alias TournamentsApi.Phases.PhaseStandings

  action_fallback TournamentsApiWeb.FallbackController

  def index(conn, %{"tournament_phase_id" => tournament_phase_id}) do
    phase_standings = Phases.list_phase_standings(tournament_phase_id)
    render(conn, "index.json", phase_standings: phase_standings)
  end

  def create(conn, %{
        "phase_standings" => phase_standings_params,
        "tournament_phase_id" => tournament_phase_id
      }) do
    phase_standings_params =
      Map.merge(phase_standings_params, %{"tournament_phase_id" => tournament_phase_id})

    with {:ok, %PhaseStandings{} = phase_standings} <-
           Phases.create_phase_standings(phase_standings_params) do
      conn
      |> put_status(:created)
      |> put_resp_header(
        "location",
        Routes.phase_standings_path(conn, :show, tournament_phase_id, phase_standings)
      )
      |> render("show.json", phase_standings: phase_standings)
    end
  end

  def show(conn, %{"id" => id, "tournament_phase_id" => tournament_phase_id}) do
    phase_standings = Phases.get_phase_standings!(id, tournament_phase_id)
    render(conn, "show.json", phase_standings: phase_standings)
  end

  def update(conn, %{
        "id" => id,
        "phase_standings" => phase_standings_params,
        "tournament_phase_id" => tournament_phase_id
      }) do
    phase_standings = Phases.get_phase_standings!(id, tournament_phase_id)

    with {:ok, %PhaseStandings{} = phase_standings} <-
           Phases.update_phase_standings(phase_standings, phase_standings_params) do
      render(conn, "show.json", phase_standings: phase_standings)
    end
  end

  def delete(conn, %{"id" => id, "tournament_phase_id" => tournament_phase_id}) do
    phase_standings = Phases.get_phase_standings!(id, tournament_phase_id)

    with {:ok, %PhaseStandings{}} <- Phases.delete_phase_standings(phase_standings) do
      send_resp(conn, :no_content, "")
    end
  end
end

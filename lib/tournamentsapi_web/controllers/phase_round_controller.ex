defmodule TournamentsApiWeb.PhaseRoundController do
  use TournamentsApiWeb, :controller

  alias TournamentsApi.Phases
  alias TournamentsApi.Phases.PhaseRound

  action_fallback TournamentsApiWeb.FallbackController

  def index(conn, %{"phase_id" => phase_id}) do
    phase_rounds = Phases.list_phase_rounds(phase_id)
    render(conn, "index.json", phase_rounds: phase_rounds)
  end

  def create(conn, %{
        "phase_round" => phase_round_params,
        "phase_id" => phase_id
      }) do
    phase_round_params = Map.merge(phase_round_params, %{"phase_id" => phase_id})

    with {:ok, %PhaseRound{} = phase_round} <- Phases.create_phase_round(phase_round_params) do
      conn
      |> put_status(:created)
      |> put_resp_header(
        "location",
        Routes.phase_round_path(conn, :show, phase_id, phase_round)
      )
      |> render("show.json", phase_round: phase_round)
    end
  end

  def show(conn, %{"id" => id, "phase_id" => phase_id}) do
    phase_round = Phases.get_phase_round!(id, phase_id)
    render(conn, "show.json", phase_round: phase_round)
  end

  def update(conn, %{
        "id" => id,
        "phase_round" => phase_round_params,
        "phase_id" => phase_id
      }) do
    phase_round = Phases.get_phase_round!(id, phase_id)

    with {:ok, %PhaseRound{} = phase_round} <-
           Phases.update_phase_round(phase_round, phase_round_params) do
      render(conn, "show.json", phase_round: phase_round)
    end
  end

  def delete(conn, %{"id" => id, "phase_id" => phase_id}) do
    phase_round = Phases.get_phase_round!(id, phase_id)

    with {:ok, %PhaseRound{}} <- Phases.delete_phase_round(phase_round) do
      send_resp(conn, :no_content, "")
    end
  end
end

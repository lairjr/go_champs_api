defmodule TournamentsApiWeb.PhaseController do
  use TournamentsApiWeb, :controller

  alias TournamentsApi.Phases
  alias TournamentsApi.Phases.Phase

  action_fallback TournamentsApiWeb.FallbackController

  def create(conn, %{
        "phase" => phase_params
      }) do
    with {:ok, %Phase{} = created_phase} <-
           Phases.create_phase(phase_params) do
      phase = Phases.get_phase!(created_phase.id)

      conn
      |> put_status(:created)
      |> put_resp_header(
        "location",
        Routes.phase_path(conn, :show, phase)
      )
      |> render("show.json", phase: phase)
    end
  end

  def show(conn, %{"id" => id}) do
    phase = Phases.get_phase!(id)
    render(conn, "show.json", phase: phase)
  end

  def update(conn, %{
        "id" => id,
        "phase" => phase_params
      }) do
    phase = Phases.get_phase!(id)

    with {:ok, %Phase{} = phase} <-
           Phases.update_phase(phase, phase_params) do
      render(conn, "show.json", phase: phase)
    end
  end

  def delete(conn, %{"id" => id}) do
    phase = Phases.get_phase!(id)

    with {:ok, %Phase{}} <- Phases.delete_phase(phase) do
      send_resp(conn, :no_content, "")
    end
  end
end

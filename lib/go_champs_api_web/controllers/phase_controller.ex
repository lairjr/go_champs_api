defmodule GoChampsApiWeb.PhaseController do
  use GoChampsApiWeb, :controller

  alias GoChampsApi.Phases
  alias GoChampsApi.Phases.Phase

  action_fallback GoChampsApiWeb.FallbackController

  plug GoChampsApiWeb.Plugs.AuthorizedPhase, :phase when action in [:create]

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

  def batch_update(conn, %{"phases" => phases_param}) do
    with {:ok, phases} <- Phases.update_phases(phases_param) do
      render(conn, "batch_list.json", phases: phases)
    end
  end

  def delete(conn, %{"id" => id}) do
    phase = Phases.get_phase!(id)

    with {:ok, %Phase{}} <- Phases.delete_phase(phase) do
      send_resp(conn, :no_content, "")
    end
  end
end

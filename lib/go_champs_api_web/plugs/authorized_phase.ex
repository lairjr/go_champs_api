defmodule GoChampsApiWeb.Plugs.AuthorizedPhase do
  import Phoenix.Controller
  import Plug.Conn

  alias GoChampsApi.Tournaments
  alias GoChampsApi.Phases

  def init(default), do: default

  def call(conn, :phase) do
    {:ok, phase} = Map.fetch(conn.params, "phase")
    {:ok, tournament_id} = Map.fetch(phase, "tournament_id")

    organization = Tournaments.get_tournament_organization!(tournament_id)
    current_user = Guardian.Plug.current_resource(conn)

    if Enum.any?(organization.members, fn member -> member.username == current_user.username end) do
      conn
    else
      conn
      |> put_status(:forbidden)
      |> text("Forbidden")
      |> halt
    end
  end

  def call(conn, :id) do
    {:ok, phase_id} = Map.fetch(conn.params, "id")

    organization = Phases.get_phase_organization!(phase_id)
    current_user = Guardian.Plug.current_resource(conn)

    if Enum.any?(organization.members, fn member -> member.username == current_user.username end) do
      conn
    else
      conn
      |> put_status(:forbidden)
      |> text("Forbidden")
      |> halt
    end
  end
end

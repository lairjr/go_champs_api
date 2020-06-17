defmodule GoChampsApiWeb.Plugs.AuthorizedDraw do
  import Phoenix.Controller
  import Plug.Conn

  alias GoChampsApi.Phases
  alias GoChampsApi.Draws

  def init(default), do: default

  def call(conn, :draw) do
    {:ok, draw} = Map.fetch(conn.params, "draw")
    {:ok, phase_id} = Map.fetch(draw, "phase_id")

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

  def call(conn, :id) do
    {:ok, draw_id} = Map.fetch(conn.params, "id")

    organization = Draws.get_draw_organization!(draw_id)
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

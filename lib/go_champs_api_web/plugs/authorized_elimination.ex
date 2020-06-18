defmodule GoChampsApiWeb.Plugs.AuthorizedElimination do
  import Phoenix.Controller
  import Plug.Conn

  alias GoChampsApi.Phases
  alias GoChampsApi.Eliminations

  def init(default), do: default

  def call(conn, :elimination) do
    {:ok, elimination} = Map.fetch(conn.params, "elimination")
    {:ok, phase_id} = Map.fetch(elimination, "phase_id")

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

  def call(conn, :eliminations) do
    {:ok, eliminations} = Map.fetch(conn.params, "eliminations")

    case Eliminations.get_eliminations_phase_id(eliminations) do
      {:ok, phase_id} ->
        organization = Phases.get_phase_organization!(phase_id)
        current_user = Guardian.Plug.current_resource(conn)

        if Enum.any?(organization.members, fn member ->
             member.username == current_user.username
           end) do
          conn
        else
          conn
          |> put_status(:forbidden)
          |> text("Forbidden")
          |> halt
        end

      {:error, message} ->
        conn
        |> put_status(:unprocessable_entity)
        |> text(message)
        |> halt
    end
  end

  def call(conn, :id) do
    {:ok, elimination_id} = Map.fetch(conn.params, "id")

    organization = Eliminations.get_elimination_organization!(elimination_id)
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

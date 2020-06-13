defmodule GoChampsApiWeb.Plugs.AuthorizedTournament do
  import Phoenix.Controller
  import Plug.Conn

  alias GoChampsApi.Organizations
  alias GoChampsApi.Tournaments

  def init(default), do: default

  def call(conn, :tournament) do
    {:ok, tournament} = Map.fetch(conn.params, "tournament")
    {:ok, organization_id} = Map.fetch(tournament, "organization_id")

    organization = Organizations.get_organization!(organization_id)
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
    {:ok, tournament_id} = Map.fetch(conn.params, "id")

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
end

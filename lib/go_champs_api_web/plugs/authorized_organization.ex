defmodule GoChampsApiWeb.Plugs.AuthorizedOrganization do
  import Phoenix.Controller
  import Plug.Conn

  alias GoChampsApi.Organizations

  def init(default), do: default

  def call(conn, :id) do
    {:ok, organization_id} = Map.fetch(conn.params, "id")

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

  def call(conn, :organization) do
    {:ok, organization} = Map.fetch(conn.params, "organization")

    current_user = Guardian.Plug.current_resource(conn)

    if Enum.any?(organization["members"], fn member ->
         member["username"] == current_user.username
       end) do
      conn
    else
      conn
      |> put_status(:forbidden)
      |> text("Forbidden")
      |> halt
    end
  end
end

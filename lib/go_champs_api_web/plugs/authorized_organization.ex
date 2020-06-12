defmodule GoChampsApiWeb.Plugs.AuthorizedOrganization do
  import Plug.Conn

  alias GoChampsApi.Organizations
  alias GoChampsApi.Accounts.User

  def init(default), do: default

  def call(conn, _params) do
    {:ok, organization_id} = Map.fetch(conn.params, "id")

    organization = Organizations.get_organization!(organization_id)
    current_user = Guardian.Plug.current_resource(conn)

    if Enum.any?(organization.members, fn member -> member.username == current_user.username end) do
      conn
    else
      conn
      |> put_status(:forbidden)
      |> halt
    end
  end
end

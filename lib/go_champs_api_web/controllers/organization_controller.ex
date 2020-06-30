defmodule GoChampsApiWeb.OrganizationController do
  use GoChampsApiWeb, :controller
  use PhoenixSwagger

  alias GoChampsApi.Organizations
  alias GoChampsApi.Organizations.Organization

  action_fallback GoChampsApiWeb.FallbackController

  plug GoChampsApiWeb.Plugs.AuthorizedOrganization, :id when action in [:update, :delete]
  plug GoChampsApiWeb.Plugs.AuthorizedOrganization, :organization when action in [:create]

  defp map_to_keyword(map) do
    Enum.map(map, fn {key, value} -> {String.to_atom(key), value} end)
  end

  def index(conn, params) do
    organizations =
      case params do
        %{"where" => where} ->
          where
          |> map_to_keyword()
          |> Organizations.list_organizations()

        _ ->
          Organizations.list_organizations()
      end

    render(conn, "index.json", organizations: organizations)
  end

  def create(conn, %{"organization" => organization_params}) do
    with {:ok, %Organization{} = organization} <-
           Organizations.create_organization(organization_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.organization_path(conn, :show, organization))
      |> render("show.json", organization: organization)
    end
  end

  def show(conn, %{"id" => id}) do
    organization = Organizations.get_organization!(id)
    render(conn, "show.json", organization: organization)
  end

  def update(conn, %{"id" => id, "organization" => organization_params}) do
    organization = Organizations.get_organization!(id)

    case Organizations.update_organization(organization, organization_params) do
      {:ok, %{organization: result_organization}} ->
        render(conn, "show.json", organization: result_organization)

      {:error, :organization, %Ecto.Changeset{} = changeset, %{}} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(GoChampsApiWeb.ChangesetView)
        |> render("error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    organization = Organizations.get_organization!(id)

    with {:ok, %Organization{}} <- Organizations.delete_organization(organization) do
      send_resp(conn, :no_content, "")
    end
  end
end

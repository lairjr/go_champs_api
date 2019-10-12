defmodule TournamentsApi.Helpers.OrganizationHelpers do
  alias TournamentsApi.Organizations

  def map_organization_id(attrs \\ %{}) do
    {:ok, organization} =
      Organizations.create_organization(%{name: "some organization", slug: "some-slug"})

    Map.merge(attrs, %{organization_id: organization.id})
  end
end

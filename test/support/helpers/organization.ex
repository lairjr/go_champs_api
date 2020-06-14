defmodule GoChampsApi.Helpers.OrganizationHelpers do
  alias GoChampsApi.Organizations

  def map_organization_id(attrs \\ %{}) do
    {:ok, organization} =
      Organizations.create_organization(%{
        name: "some organization",
        slug: "some-slug",
        members: [
          %{
            username: "someuser"
          }
        ]
      })

    Map.merge(attrs, %{organization_id: organization.id})
  end

  def map_organization_id_with_other_member(attrs \\ %{}) do
    {:ok, organization} =
      Organizations.create_organization(%{
        name: "some organization",
        slug: "some-slug",
        members: [
          %{
            username: "someotheruser"
          }
        ]
      })

    Map.merge(attrs, %{organization_id: organization.id})
  end
end

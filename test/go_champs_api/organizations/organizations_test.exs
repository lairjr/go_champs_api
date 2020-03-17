defmodule GoChampsApi.OrganizationsTest do
  use GoChampsApi.DataCase

  alias GoChampsApi.Organizations
  alias GoChampsApi.Tournaments

  describe "organizations" do
    alias GoChampsApi.Organizations.Organization
    alias GoChampsApi.Tournaments.Tournament

    @valid_attrs %{slug: "some slug", name: "some name"}
    @update_attrs %{slug: "some updated slug", name: "some updated name"}
    @invalid_attrs %{slug: nil, name: nil}

    def organization_fixture(attrs \\ %{}) do
      {:ok, organization} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Organizations.create_organization()

      organization
    end

    test "list_organizations/0 returns all organizations" do
      organization = organization_fixture()
      assert Organizations.list_organizations() == [organization]
    end

    test "get_organization!/1 returns the organization with given id" do
      organization = organization_fixture()
      assert Organizations.get_organization!(organization.id) == organization
    end

    test "create_organization/1 with valid data creates a organization" do
      assert {:ok, %Organization{} = organization} =
               Organizations.create_organization(@valid_attrs)

      assert organization.slug == "some slug"
      assert organization.name == "some name"
    end

    test "create_organization/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Organizations.create_organization(@invalid_attrs)
    end

    test "update_organization/2 with valid data updates the organization" do
      organization = organization_fixture()

      assert {:ok, %{organization: result_organization}} =
               Organizations.update_organization(organization, @update_attrs)

      assert result_organization.slug == "some updated slug"
      assert result_organization.name == "some updated name"
    end

    test "update_organization/2 with invalid data returns error changeset" do
      organization = organization_fixture()

      assert {:error, :organization, %Ecto.Changeset{}, %{}} =
               Organizations.update_organization(organization, @invalid_attrs)

      assert organization == Organizations.get_organization!(organization.id)
    end

    test "when slug is updated, updates pertaining tournaments" do
      organization = organization_fixture()

      {:ok, %Tournament{} = tournament} =
        Tournaments.create_tournament(%{
          name: "some name",
          slug: "some-slug",
          organization_id: organization.id,
          organization_slug: organization.slug
        })

      Organizations.update_organization(organization, @update_attrs)

      update_tournament = Tournaments.get_tournament!(tournament.id)

      assert update_tournament.organization_slug == "some updated slug"
    end

    test "delete_organization/1 deletes the organization" do
      organization = organization_fixture()
      assert {:ok, %Organization{}} = Organizations.delete_organization(organization)
      assert_raise Ecto.NoResultsError, fn -> Organizations.get_organization!(organization.id) end
    end

    test "change_organization/1 returns a organization changeset" do
      organization = organization_fixture()
      assert %Ecto.Changeset{} = Organizations.change_organization(organization)
    end
  end
end

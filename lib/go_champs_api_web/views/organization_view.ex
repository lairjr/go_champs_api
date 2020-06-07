defmodule GoChampsApiWeb.OrganizationView do
  use GoChampsApiWeb, :view
  alias GoChampsApiWeb.OrganizationView

  def render("index.json", %{organizations: organizations}) do
    %{data: render_many(organizations, OrganizationView, "organization.json")}
  end

  def render("show.json", %{organization: organization}) do
    %{data: render_one(organization, OrganizationView, "complete_organization.json")}
  end

  def render("organization.json", %{organization: organization}) do
    %{id: organization.id, name: organization.name, slug: organization.slug}
  end

  def render("complete_organization.json", %{organization: organization}) do
    %{
      id: organization.id,
      name: organization.name,
      slug: organization.slug,
      members: render_many(organization.members, OrganizationView, "member.json")
    }
  end

  def render("member.json", %{organization: member}) do
    %{username: member.username}
  end
end

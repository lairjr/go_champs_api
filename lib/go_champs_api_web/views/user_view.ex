defmodule GoChampsApiWeb.UserView do
  use GoChampsApiWeb, :view
  alias GoChampsApiWeb.OrganizationView

  def render("show.json", %{user: user, organizations: organizations}) do
    %{
      data: %{
        email: user.email,
        username: user.username,
        organizations: render_many(organizations, OrganizationView, "organization.json")
      }
    }
  end

  def render("user.json", %{user: user, token: token}) do
    %{
      data: %{
        email: user.email,
        token: token,
        username: user.username
      }
    }
  end
end

defmodule GoChampsApiWeb.RecentlyViewView do
  use GoChampsApiWeb, :view
  alias GoChampsApiWeb.OrganizationView
  alias GoChampsApiWeb.RecentlyViewView

  def render("index.json", %{recently_view: recently_view}) do
    %{data: render_many(recently_view, RecentlyViewView, "recently_view_list.json")}
  end

  def render("show.json", %{recently_view: recently_view}) do
    %{data: render_one(recently_view, RecentlyViewView, "recently_view.json")}
  end

  def render("recently_view.json", %{recently_view: recently_view}) do
    %{id: recently_view.id, tournament_id: recently_view.tournament_id}
  end

  def render("recently_view_list.json", %{recently_view: recently_view}) do
    %{
      tournament: %{
        id: recently_view.tournament.id,
        name: recently_view.tournament.name,
        slug: recently_view.tournament.slug,
        organization:
          render_one(recently_view.tournament.organization, OrganizationView, "organization.json")
      },
      views: recently_view.views
    }
  end
end

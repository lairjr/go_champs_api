defmodule TournamentsApiWeb.SearchView do
  use TournamentsApiWeb, :view
  alias TournamentsApiWeb.SearchView
  alias TournamentsApiWeb.OrganizationView

  def render("index.json", %{tournaments: tournaments}) do
    %{data: render_many(tournaments, SearchView, "result.json")}
  end

  def render("result.json", %{search: tournament}) do
    %{
      id: tournament.id,
      name: tournament.name,
      slug: tournament.slug,
      organization: render_one(tournament.organization, OrganizationView, "organization.json")
    }
  end
end

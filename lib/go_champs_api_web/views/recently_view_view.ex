defmodule GoChampsApiWeb.RecentlyViewView do
  use GoChampsApiWeb, :view
  alias GoChampsApiWeb.RecentlyViewView

  def render("index.json", %{recently_view: recently_view}) do
    %{data: render_many(recently_view, RecentlyViewView, "recently_view.json")}
  end

  def render("show.json", %{recently_view: recently_view}) do
    %{data: render_one(recently_view, RecentlyViewView, "recently_view.json")}
  end

  def render("recently_view.json", %{recently_view: recently_view}) do
    %{id: recently_view.id}
  end
end

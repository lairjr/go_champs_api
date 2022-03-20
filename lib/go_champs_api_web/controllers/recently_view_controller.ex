defmodule GoChampsApiWeb.RecentlyViewController do
  use GoChampsApiWeb, :controller

  alias GoChampsApi.RecentlyViews
  alias GoChampsApi.RecentlyViews.RecentlyView

  action_fallback GoChampsApiWeb.FallbackController

  def index(conn, _params) do
    recently_view = RecentlyViews.list_recently_view()
    render(conn, "index.json", recently_view: recently_view)
  end

  def create(conn, %{"recently_view" => recently_view_params}) do
    with {:ok, %RecentlyView{} = recently_view} <-
           RecentlyViews.create_recently_view(recently_view_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.v1_recently_view_path(conn, :show, recently_view))
      |> render("show.json", recently_view: recently_view)
    end
  end

  def show(conn, %{"id" => id}) do
    recently_view = RecentlyViews.get_recently_view!(id)
    render(conn, "show.json", recently_view: recently_view)
  end
end

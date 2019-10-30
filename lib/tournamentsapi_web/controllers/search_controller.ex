defmodule TournamentsApiWeb.SearchController do
  use TournamentsApiWeb, :controller

  alias TournamentsApi.Tournaments

  action_fallback TournamentsApiWeb.FallbackController

  def index(conn, params) do
    tournaments =
      case params do
        %{"term" => term} ->
          term
          |> Tournaments.search_tournaments()

        _ ->
          Tournaments.list_tournaments()
      end

    render(conn, "index.json", tournaments: tournaments)
  end
end

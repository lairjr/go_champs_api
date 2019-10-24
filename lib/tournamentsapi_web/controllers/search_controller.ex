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

    conn
    |> put_view(TournamentsApiWeb.TournamentView)
    |> render("index.json", tournaments: tournaments)
  end
end

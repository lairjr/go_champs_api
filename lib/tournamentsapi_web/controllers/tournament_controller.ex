defmodule TournamentsapiWeb.TournamentController do
  use TournamentsapiWeb, :controller

  def index(conn, _params) do
    tournaments = [
        %{id: "tournamente-one", name: "Liga Municipal de Basquete", link: "liga-municipal-de-basquete"},
        %{id: "tournamente-two", name: "Liga Municipal de Volei", link: "liga-municipal-de-volei"},
    ]
    json(conn, tournaments)
  end
end
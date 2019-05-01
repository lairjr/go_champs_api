defmodule TournamentsApiWeb.TournamentController do
  use TournamentsApiWeb, :controller

  def index(conn, _params) do
    tournaments = [
      %{
        id: "tournamente-one",
        name: "Liga Municipal de Basquete",
        link: "liga-municipal-de-basquete"
      },
      %{id: "tournamente-two", name: "Liga Municipal de Volei", link: "liga-municipal-de-volei"}
    ]

    json(conn, tournaments)
  end

  def show(conn, _params) do
    tournament = %{
      id: "tournamente-two",
      name: "Liga Municipal de Volei",
      link: "liga-municipal-de-volei",
      currentGroupView: "standings",
      groups: [
        %{
          name: "Group A",
          view: "standings",
          standings: %{
            0 => %{team: %{id: "panteras", name: "Panteras"}, stats: %{wins: 9, loses: 8}},
            1 => %{team: %{id: "titios", name: "Titios"}, stats: %{wins: 8, loses: 9}},
            2 => %{team: %{id: "abpa", name: "ABPA"}, stats: %{wins: 7, loses: 10}}
          },
          bracket: nil
        }
      ]
    }

    json(conn, tournament)
  end
end

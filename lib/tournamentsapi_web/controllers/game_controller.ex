defmodule TournamentsApiWeb.GameController do
  use TournamentsApiWeb, :controller

  def index(conn, _params) do
    games = [
      %{
        id: "game-one",
        homeTeam: %{id: "panteras-poa", name: "Panteras"},
        homeScore: 90,
        awayTeam: %{id: "veteranos-poa", name: "Veterandos"},
        awayScore: 80,
        dateTime: "2011-10-05T14:48:00.000Z"
      },
      %{
        id: "game-two",
        homeTeam: %{id: "titios-poa", name: "Titios"},
        homeScore: 80,
        awayTeam: %{id: "mustangs-poa", name: "Mustangs"},
        awayScore: 80,
        dateTime: "2011-10-05T14:48:00.000Z"
      }
    ]

    json(conn, games)
  end
end

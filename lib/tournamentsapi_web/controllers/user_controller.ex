defmodule TournamentsApiWeb.UserController do
  use TournamentsApiWeb, :controller

  def index(conn, _params) do
    users = [
      %{id: "user-one", name: "Secretaria Municipal de Esportes"},
      %{id: "user-two", name: "Clube Esportivo"}
    ]

    json(conn, users)
  end
end

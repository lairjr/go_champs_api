defmodule TournamentsapiWeb.UserController do
  use TournamentsapiWeb, :controller

  def index(conn, _params) do
    json(conn, %{id: "user-id"})
  end
end
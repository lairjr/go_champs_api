defmodule GoChampsApiWeb.Plugs.AuthorizedGame do
  import Phoenix.Controller
  import Plug.Conn

  alias GoChampsApi.Phases
  alias GoChampsApi.Games

  def init(default), do: default

  def call(conn, :game) do
    {:ok, game} = Map.fetch(conn.params, "game")
    {:ok, phase_id} = Map.fetch(game, "phase_id")

    organization = Phases.get_phase_organization!(phase_id)
    current_user = Guardian.Plug.current_resource(conn)

    if Enum.any?(organization.members, fn member -> member.username == current_user.username end) do
      conn
    else
      conn
      |> put_status(:forbidden)
      |> text("Forbidden")
      |> halt
    end
  end

  def call(conn, :id) do
    {:ok, game_id} = Map.fetch(conn.params, "id")

    organization = Games.get_game_organization!(game_id)
    current_user = Guardian.Plug.current_resource(conn)

    if Enum.any?(organization.members, fn member -> member.username == current_user.username end) do
      conn
    else
      conn
      |> put_status(:forbidden)
      |> text("Forbidden")
      |> halt
    end
  end
end

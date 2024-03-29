defmodule GoChampsApiWeb.FixedPlayerStatsTableController do
  use GoChampsApiWeb, :controller

  alias GoChampsApi.FixedPlayerStatsTables
  alias GoChampsApi.FixedPlayerStatsTables.FixedPlayerStatsTable

  action_fallback GoChampsApiWeb.FallbackController

  plug GoChampsApiWeb.Plugs.AuthorizedFixedPlayerStatsTable, :id when action in [:delete, :update]

  plug GoChampsApiWeb.Plugs.AuthorizedFixedPlayerStatsTable,
       :fixed_player_stats_table when action in [:create]

  defp map_to_keyword(map) do
    Enum.map(map, fn {key, value} -> {String.to_atom(key), value} end)
  end

  def index(conn, params) do
    fixed_player_stats_tables =
      case params do
        %{"where" => where} ->
          where
          |> map_to_keyword()
          |> FixedPlayerStatsTables.list_fixed_player_stats_tables()

        _ ->
          # TODO (lairjr): Return error if no filter is provided
          []
      end

    render(conn, "index.json", fixed_player_stats_table: fixed_player_stats_tables)
  end

  def create(conn, %{"fixed_player_stats_table" => fixed_player_stats_table_params}) do
    with {:ok, %FixedPlayerStatsTable{} = fixed_player_stats_table} <-
           FixedPlayerStatsTables.create_fixed_player_stats_table(fixed_player_stats_table_params) do
      conn
      |> put_status(:created)
      |> put_resp_header(
        "location",
        Routes.v1_fixed_player_stats_table_path(conn, :show, fixed_player_stats_table)
      )
      |> render("show.json", fixed_player_stats_table: fixed_player_stats_table)
    end
  end

  def show(conn, %{"id" => id}) do
    fixed_player_stats_table = FixedPlayerStatsTables.get_fixed_player_stats_table!(id)
    render(conn, "show.json", fixed_player_stats_table: fixed_player_stats_table)
  end

  def update(conn, %{"id" => id, "fixed_player_stats_table" => fixed_player_stats_table_params}) do
    fixed_player_stats_table = FixedPlayerStatsTables.get_fixed_player_stats_table!(id)

    with {:ok, %FixedPlayerStatsTable{} = fixed_player_stats_table} <-
           FixedPlayerStatsTables.update_fixed_player_stats_table(
             fixed_player_stats_table,
             fixed_player_stats_table_params
           ) do
      render(conn, "show.json", fixed_player_stats_table: fixed_player_stats_table)
    end
  end

  def delete(conn, %{"id" => id}) do
    fixed_player_stats_table = FixedPlayerStatsTables.get_fixed_player_stats_table!(id)

    with {:ok, %FixedPlayerStatsTable{}} <-
           FixedPlayerStatsTables.delete_fixed_player_stats_table(fixed_player_stats_table) do
      send_resp(conn, :no_content, "")
    end
  end
end

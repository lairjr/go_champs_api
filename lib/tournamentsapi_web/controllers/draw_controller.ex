defmodule TournamentsApiWeb.DrawController do
  use TournamentsApiWeb, :controller

  alias TournamentsApi.Draws
  alias TournamentsApi.Draws.Draw

  action_fallback TournamentsApiWeb.FallbackController

  def create(conn, %{"draw" => draw_params}) do
    with {:ok, %Draw{} = draw} <- Draws.create_draw(draw_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.draw_path(conn, :show, draw))
      |> render("show.json", draw: draw)
    end
  end

  def show(conn, %{"id" => id}) do
    draw = Draws.get_draw!(id)
    render(conn, "show.json", draw: draw)
  end

  def update(conn, %{"id" => id, "draw" => draw_params}) do
    draw = Draws.get_draw!(id)

    with {:ok, %Draw{} = draw} <- Draws.update_draw(draw, draw_params) do
      render(conn, "show.json", draw: draw)
    end
  end

  def delete(conn, %{"id" => id}) do
    draw = Draws.get_draw!(id)

    with {:ok, %Draw{}} <- Draws.delete_draw(draw) do
      send_resp(conn, :no_content, "")
    end
  end
end

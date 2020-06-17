defmodule GoChampsApiWeb.DrawController do
  use GoChampsApiWeb, :controller

  alias GoChampsApi.Draws
  alias GoChampsApi.Draws.Draw

  action_fallback GoChampsApiWeb.FallbackController

  plug GoChampsApiWeb.Plugs.AuthorizedDraw, :draw when action in [:create]
  plug GoChampsApiWeb.Plugs.AuthorizedDraw, :id when action in [:delete, :update]

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

  def batch_update(conn, %{"draws" => draws_param}) do
    with {:ok, draws} <- Draws.update_draws(draws_param) do
      render(conn, "batch_list.json", draws: draws)
    end
  end

  def delete(conn, %{"id" => id}) do
    draw = Draws.get_draw!(id)

    with {:ok, %Draw{}} <- Draws.delete_draw(draw) do
      send_resp(conn, :no_content, "")
    end
  end
end

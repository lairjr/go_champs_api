defmodule GoChampsApiWeb.UserView do
  use GoChampsApiWeb, :view

  def render("show.json", %{user: user}) do
    %{
      data: %{
        email: user.email,
        username: user.username,
        organizations: []
      }
    }
  end

  def render("user.json", %{user: user, token: token}) do
    %{
      data: %{
        email: user.email,
        token: token,
        username: user.username
      }
    }
  end
end

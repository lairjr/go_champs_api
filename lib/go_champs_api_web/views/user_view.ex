defmodule GoChampsApiWeb.UserView do
  use GoChampsApiWeb, :view

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

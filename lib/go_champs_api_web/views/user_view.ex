defmodule GoChampsApiWeb.UserView do
  use GoChampsApiWeb, :view
  alias GoChampsApiWeb.UserView

  def render("user.json", %{user: user, token: token}) do
    %{
      email: user.email,
      token: token
    }
  end
end

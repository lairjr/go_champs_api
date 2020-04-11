defmodule GoChampsApiWeb.Auth.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :go_champs_api,
    module: GoChampsApiWeb.Auth.Guardian,
    error_handler: GoChampsApiWeb.Auth.ErrorHandler

  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end

config :my_app, :phoenix_swagger,
  swagger_files: %{
    "priv/static/swagger.json" => [
      router: TournamentsApiWeb.Router,     # phoenix routes will be converted to swagger paths
      endpoint: TournamentsApiWeb.Endpoint  # (optional) endpoint config used to set host, port and https schemes.
    ]
  }
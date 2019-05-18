# # Script for populating the database. You can run it as:
# #
# #     mix run priv/repo/seeds.exs
# #
# # Inside the script, you can read and write to any of your
# # repositories directly:
# #
# #     TournamentsApi.Repo.insert!(%TournamentsApi.SomeSchema{})
# #
# # We recommend using the bang functions (`insert!`, `update!`
# # and so on) as they will fail if something goes wrong.

# alias TournamentsApi.Repo

# # Add organizations

# alias TournamentsApi.Organizations.Organization

# sec_organization =
#   Repo.insert!(%Organization{name: "Secretaria Municipal de Esportes", slug: "sec-mun-esportes"})

# clube_esportivo =
#   Repo.insert!(%Organization{name: "Clube Esportivo Banrisul", slug: "clube-esportivo-banrisul"})

# # Add tournaments

# alias TournamentsApi.Tournaments.Tournament

# municipal = Repo.insert!(%Tournament{name: "Liga Municipal", slug: "liga-municipal", organization_id: sec_organization.id, organization_slug: sec_organization.slug})
# lawson = Repo.insert!(%Tournament{name: "Taca Eduardo Lawson", slug: "taca-lawson", organization_id: sec_organization.id, organization_slug: sec_organization.slug})
# liga_amizade = Repo.insert!(%Tournament{name: "Liga de Amizade", slug: "liga-da-amizade", organization_id: clube_esportivo.id, organization_slug: clube_esportivo.slug})

# # Add teams

# alias TournamentsApi.Teams.Team

# illumis = Repo.insert!(%Team{name: "Illumis", slug: "illumis"})
# quiuchin = Repo.insert!(%Team{name: "Quiuchin", slug: "quiuchin"})
# aabb = Repo.insert!(%Team{name: "AABB Sao Leo", slug: "aabb"})
# aposentadas = Repo.insert!(%Team{name: "Aposentadas", slug: "aposentadas"})
# mvm = Repo.insert!(%Team{name: "MVM", slug: "mvm"})
# panteras = Repo.insert!(%Team{name: "Panteras", slug: "panteras"})
# titios = Repo.insert!(%Team{name: "Titios", slug: "titios"})
# old_scholl = Repo.insert!(%Team{name: "Old Scholl", slug: "Old Scholl"})
# pucrs = Repo.insert!(%Team{name: "Pucrs", slug: "pucrs"})

# # Add tournament_groups

# alias TournamentsApi.Tournaments.TournamentGroup

# municipal_groupo = Repo.insert!(%TournamentGroup{tournament_id: municipal.id})
# lawson_grupo = Repo.insert!(%TournamentGroup{tournament_id: lawson.id})
# amizade_grupo_a = Repo.insert!(%TournamentGroup{tournament_id: liga_amizade.id, name: "Grupo A"})
# amizade_grupo_b = Repo.insert!(%TournamentGroup{tournament_id: liga_amizade.id, name: "Grupo B"})

# # Add tournament_teams

# alias TournamentsApi.Tournaments.TournamentTeam

# Repo.insert!(%TournamentTeam{tournament_id: municipal.id, name: "Time 1"})
# Repo.insert!(%TournamentTeam{tournament_id: municipal.id, name: "Time 2"})
# Repo.insert!(%TournamentTeam{tournament_id: municipal.id, name: "Time 3"})
# Repo.insert!(%TournamentTeam{tournament_id: municipal.id, name: "Time 4"})
# Repo.insert!(%TournamentTeam{tournament_id: lawson.id, name: "Time A"})
# Repo.insert!(%TournamentTeam{tournament_id: lawson.id, name: "Time B"})
# Repo.insert!(%TournamentTeam{tournament_id: lawson.id, name: "Time C"})
# Repo.insert!(%TournamentTeam{tournament_id: lawson.id, name: "Time D"})
# Repo.insert!(%TournamentTeam{tournament_id: lawson.id, name: "Time E"})

# # Add games

# alias TournamentsApi.Games.Game

# date1 = DateTime.truncate(DateTime.utc_now(), :second)
# date2 = DateTime.truncate(DateTime.utc_now(), :second)
# date3 = DateTime.truncate(DateTime.utc_now(), :second)
# date4 = DateTime.truncate(DateTime.utc_now(), :second)
# date5 = DateTime.truncate(DateTime.utc_now(), :second)
# date6 = DateTime.truncate(DateTime.utc_now(), :second)
# date7 = DateTime.truncate(DateTime.utc_now(), :second)
# date8 = DateTime.truncate(DateTime.utc_now(), :second)
# date9 = DateTime.truncate(DateTime.utc_now(), :second)
# date10 = DateTime.truncate(DateTime.utc_now(), :second)
# date11 = DateTime.truncate(DateTime.utc_now(), :second)
# date12 = DateTime.truncate(DateTime.utc_now(), :second)

# game_municipal_1 =
#   Repo.insert!(%Game{away_team_name: "Time 1", home_team_name: "Time 2", datetime: date1})

# game_municipal_2 =
#   Repo.insert!(%Game{away_team_name: "Time 3", home_team_name: "Time 4", datetime: date2})

# game_municipal_3 =
#   Repo.insert!(%Game{away_team_name: "Time 1", home_team_name: "Time 3", datetime: date3})

# game_municipal_4 =
#   Repo.insert!(%Game{away_team_name: "Time 2", home_team_name: "Time 4", datetime: date4})

# game_municipal_5 =
#   Repo.insert!(%Game{away_team_name: "Time 1", home_team_name: "Time 4", datetime: date5})

# game_municipal_6 =
#   Repo.insert!(%Game{away_team_name: "Time 2", home_team_name: "Time 3", datetime: date6})

# game_lawson_1 =
#   Repo.insert!(%Game{away_team_name: "Time A", home_team_name: "Time B", datetime: date7})

# game_lawson_2 =
#   Repo.insert!(%Game{away_team_name: "Time C", home_team_name: "Time D", datetime: date8})

# game_lawson_3 =
#   Repo.insert!(%Game{away_team_name: "Time A", home_team_name: "Time C", datetime: date9})

# game_lawson_4 =
#   Repo.insert!(%Game{away_team_name: "Time B", home_team_name: "Time D", datetime: date10})

# game_lawson_5 =
#   Repo.insert!(%Game{away_team_name: "Time A", home_team_name: "Time D", datetime: date11})

# game_lawson_6 =
#   Repo.insert!(%Game{away_team_name: "Time B", home_team_name: "Time C", datetime: date1})

# # Add tournament_game

# alias TournamentsApi.Tournaments.TournamentGame

# Repo.insert!(%TournamentGame{tournament_id: municipal.id, game_id: game_municipal_1.id})
# Repo.insert!(%TournamentGame{tournament_id: municipal.id, game_id: game_municipal_2.id})
# Repo.insert!(%TournamentGame{tournament_id: municipal.id, game_id: game_municipal_3.id})
# Repo.insert!(%TournamentGame{tournament_id: municipal.id, game_id: game_municipal_4.id})
# Repo.insert!(%TournamentGame{tournament_id: municipal.id, game_id: game_municipal_5.id})
# Repo.insert!(%TournamentGame{tournament_id: municipal.id, game_id: game_municipal_6.id})

# Repo.insert!(%TournamentGame{tournament_id: lawson.id, game_id: game_lawson_1.id})
# Repo.insert!(%TournamentGame{tournament_id: lawson.id, game_id: game_lawson_2.id})
# Repo.insert!(%TournamentGame{tournament_id: lawson.id, game_id: game_lawson_3.id})
# Repo.insert!(%TournamentGame{tournament_id: lawson.id, game_id: game_lawson_4.id})
# Repo.insert!(%TournamentGame{tournament_id: lawson.id, game_id: game_lawson_5.id})
# Repo.insert!(%TournamentGame{tournament_id: lawson.id, game_id: game_lawson_6.id})

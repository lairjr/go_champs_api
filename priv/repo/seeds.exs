# # Script for populating the database. You can run it as:
# #
# #     mix run priv/repo/seeds.exs
# #
# # Inside the script, you can read and write to any of your
# # repositories directly:
# #
# #     GoChampsApi.Repo.insert!(%GoChampsApi.SomeSchema{})
# #
# # We recommend using the bang functions (`insert!`, `update!`
# # and so on) as they will fail if something goes wrong.

# alias GoChampsApi.Repo

# # Add organizations

# alias GoChampsApi.Organizations.Organization

# sec_organization =
#   Repo.insert!(%Organization{name: "Secretaria Municipal de Esportes", slug: "sec-mun-esportes"})

# clube_esportivo =
#   Repo.insert!(%Organization{name: "Clube Esportivo Banrisul", slug: "clube-esportivo-banrisul"})

# # Add tournaments

# alias GoChampsApi.Tournaments.Tournament

# municipal =
#   Repo.insert!(%Tournament{
#     name: "Liga Municipal",
#     slug: "liga-municipal",
#     organization_id: sec_organization.id,
#     organization_slug: sec_organization.slug
#   })

# lawson =
#   Repo.insert!(%Tournament{
#     name: "Taca Eduardo Lawson",
#     slug: "taca-lawson",
#     organization_id: sec_organization.id,
#     organization_slug: sec_organization.slug
#   })

# liga_amizade =
#   Repo.insert!(%Tournament{
#     name: "Liga de Amizade",
#     slug: "liga-da-amizade",
#     organization_id: clube_esportivo.id,
#     organization_slug: clube_esportivo.slug
#   })

# # Add teams

# alias GoChampsApi.Teams.Team

# illumis = Repo.insert!(%Team{name: "Illumis"})
# quiuchin = Repo.insert!(%Team{name: "Quiuchin"})
# aabb = Repo.insert!(%Team{name: "AABB Sao Leo"})
# aposentadas = Repo.insert!(%Team{name: "Aposentadas"})
# mvm = Repo.insert!(%Team{name: "MVM"})
# panteras = Repo.insert!(%Team{name: "Panteras"})
# titios = Repo.insert!(%Team{name: "Titios"})
# old_scholl = Repo.insert!(%Team{name: "Old Scholl"})
# pucrs = Repo.insert!(%Team{name: "Pucrs"})

# # Add teams

# alias GoChampsApi.Teams.Team

# municipal_team_1 = Repo.insert!(%Team{tournament_id: municipal.id, name: "Time 1"})
# municipal_team_2 = Repo.insert!(%Team{tournament_id: municipal.id, name: "Time 2"})
# municipal_team_3 = Repo.insert!(%Team{tournament_id: municipal.id, name: "Time 3"})
# municipal_team_4 = Repo.insert!(%Team{tournament_id: municipal.id, name: "Time 4"})
# lawson_team_a = Repo.insert!(%Team{tournament_id: lawson.id, name: "Time A"})
# lawson_team_b = Repo.insert!(%Team{tournament_id: lawson.id, name: "Time B"})
# lawson_team_c = Repo.insert!(%Team{tournament_id: lawson.id, name: "Time C"})
# lawson_team_d = Repo.insert!(%Team{tournament_id: lawson.id, name: "Time D"})
# lawson_team_e = Repo.insert!(%Team{tournament_id: lawson.id, name: "Time E"})

# # Add phases

# alias GoChampsApi.Phases.Phase

# municipal_phase =
#   Repo.insert!(%Phase{
#     order: 1,
#     title: "Turno",
#     type: "elimination",
#     tournament_id: municipal.id,
#     elimination_stats: [%{title: "Wins"}, %{title: "Loses"}]
#   })

# lawson_phase =
#   Repo.insert!(%Phase{order: 1, title: "Turno", type: "draw", tournament_id: lawson.id})

# # Add elimination

# alias GoChampsApi.Eliminations.Elimination

# [wins, loses] = municipal_phase.elimination_stats

# municipal_elimination =
#   Repo.insert!(%Elimination{
#     phase_id: municipal_phase.id,
#     team_stats: [
#       %{
#         team_id: municipal_team_4.id,
#         stats: %{
#           wins.id => "10",
#           loses.id => "0"
#         }
#       },
#       %{
#         team_id: municipal_team_1.id,
#         stats: %{
#           wins.id => "9",
#           loses.id => "1"
#         }
#       },
#       %{
#         team_id: municipal_team_3.id,
#         stats: %{
#           wins.id => "8",
#           loses.id => "2"
#         }
#       },
#       %{
#         team_id: municipal_team_2.id,
#         stats: %{
#           wins.id => "7",
#           loses.id => "3"
#         }
#       }
#     ]
#   })

# # Add draws

# alias GoChampsApi.Draws.Draw

# lawson_round1 =
#   Repo.insert!(%Draw{
#     order: 1,
#     title: "Semi final",
#     phase_id: lawson_phase.id,
#     matches: [
#       %{
#         first_team_id: lawson_team_c.id,
#         first_team_parent_id: nil,
#         first_team_placeholder: "Primeiro",
#         first_team_score: "1",
#         second_team_id: lawson_team_b.id,
#         second_team_parent_id: nil,
#         second_team_placeholder: "Quarto",
#         second_team_score: "0"
#       },
#       %{
#         first_team_id: lawson_team_d.id,
#         first_team_parent_id: nil,
#         first_team_placeholder: "Segundo",
#         first_team_score: "1",
#         second_team_id: lawson_team_a.id,
#         second_team_parent_id: nil,
#         second_team_placeholder: "Terceiro",
#         second_team_score: "2"
#       }
#     ]
#   })

# [round1_match1, round2_match2] = lawson_round1.matches

# lawson_round2 =
#   Repo.insert!(%Draw{
#     order: 2,
#     title: "Final",
#     phase_id: lawson_phase.id,
#     matches: [
#       %{
#         first_team_id: lawson_team_c.id,
#         first_team_parent_id: round1_match1.id,
#         first_team_placeholder: "Ganhador S1",
#         first_team_score: "0",
#         second_team_id: lawson_team_a.id,
#         second_team_parent_id: round2_match2.id,
#         second_team_placeholder: "Ganhador S2",
#         second_team_score: "0"
#       }
#     ]
#   })

# # Add game

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

# alias GoChampsApi.Games.Game

# Repo.insert!(%Game{
#   phase_id: municipal_phase.id,
#   away_team_id: municipal_team_1.id,
#   home_team_id: municipal_team_2.id,
#   datetime: date1
# })

# Repo.insert!(%Game{
#   phase_id: municipal_phase.id,
#   away_team_id: municipal_team_3.id,
#   home_team_id: municipal_team_4.id,
#   datetime: date2
# })

# Repo.insert!(%Game{
#   phase_id: municipal_phase.id,
#   away_team_id: municipal_team_1.id,
#   home_team_id: municipal_team_3.id,
#   datetime: date3
# })

# Repo.insert!(%Game{
#   phase_id: municipal_phase.id,
#   away_team_id: municipal_team_4.id,
#   home_team_id: municipal_team_2.id,
#   datetime: date4
# })

# Repo.insert!(%Game{
#   phase_id: municipal_phase.id,
#   away_team_id: municipal_team_1.id,
#   home_team_id: municipal_team_4.id,
#   datetime: date5
# })

# Repo.insert!(%Game{
#   phase_id: municipal_phase.id,
#   away_team_id: municipal_team_2.id,
#   home_team_id: municipal_team_3.id,
#   datetime: date6
# })

# Repo.insert!(%Game{
#   phase_id: lawson_phase.id,
#   away_team_id: lawson_team_a.id,
#   home_team_id: lawson_team_b.id,
#   datetime: date7
# })

# Repo.insert!(%Game{
#   phase_id: lawson_phase.id,
#   away_team_id: lawson_team_c.id,
#   home_team_id: lawson_team_d.id,
#   datetime: date8
# })

# Repo.insert!(%Game{
#   phase_id: lawson_phase.id,
#   away_team_id: lawson_team_e.id,
#   home_team_id: lawson_team_a.id,
#   datetime: date9
# })

# Repo.insert!(%Game{
#   phase_id: lawson_phase.id,
#   away_team_id: lawson_team_b.id,
#   home_team_id: lawson_team_c.id,
#   datetime: date10
# })

# Repo.insert!(%Game{
#   phase_id: lawson_phase.id,
#   away_team_id: lawson_team_d.id,
#   home_team_id: lawson_team_e.id,
#   datetime: date11
# })

# Repo.insert!(%Game{
#   phase_id: lawson_phase.id,
#   away_team_id: lawson_team_a.id,
#   home_team_id: lawson_team_c.id,
#   datetime: date12
# })

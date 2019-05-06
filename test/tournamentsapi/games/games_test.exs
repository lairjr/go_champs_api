defmodule TournamentsApi.GamesTest do
  use TournamentsApi.DataCase

  alias TournamentsApi.Games

  describe "games" do
    alias TournamentsApi.Games.Game

    @valid_attrs %{
      away_score: 42,
      away_team_name: "some away team name",
      datetime: "2010-04-17T14:00:00Z",
      home_score: 42,
      home_team_name: "some home team name",
      location: "some location"
    }
    @update_attrs %{
      away_score: 43,
      away_team_name: "some updated away team name",
      datetime: "2011-05-18T15:01:01Z",
      home_score: 43,
      home_team_name: "some updated home team name",
      location: "some updated location"
    }
    @invalid_attrs %{away_score: nil, datetime: nil, home_score: nil, location: nil}

    def game_fixture(attrs \\ %{}) do
      {:ok, game} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Games.create_game()
      game
    end

    test "list_games/0 returns all games" do
      game = game_fixture()
      assert Games.list_games() == [game]
    end

    test "get_game!/1 returns the game with given id" do
      game = game_fixture()
      assert Games.get_game!(game.id).id == game.id
    end

    test "create_game/1 with valid data creates a game" do
      assert {:ok, %Game{} = game} = Games.create_game(@valid_attrs)
      assert game.away_score == 42
      assert game.datetime == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
      assert game.home_score == 42
      assert game.location == "some location"
    end

    test "create_game/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Games.create_game(@invalid_attrs)
    end

    test "update_game/2 with valid data updates the game" do
      game = game_fixture()
      assert {:ok, %Game{} = game} = Games.update_game(game, @update_attrs)
      assert game.away_score == 43
      assert game.datetime == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
      assert game.home_score == 43
      assert game.location == "some updated location"
    end

    test "update_game/2 with invalid data returns error changeset" do
      game = game_fixture()
      assert {:error, %Ecto.Changeset{}} = Games.update_game(game, @invalid_attrs)
      result_game = Games.get_game!(game.id)
      assert game.away_score == result_game.away_score
      assert game.away_team_name == result_game.away_team_name
      assert game.datetime == result_game.datetime
      assert game.home_score == result_game.home_score
      assert game.home_team_name == result_game.home_team_name
      assert game.location == result_game.location
    end

    test "delete_game/1 deletes the game" do
      game = game_fixture()
      assert {:ok, %Game{}} = Games.delete_game(game)
      assert_raise Ecto.NoResultsError, fn -> Games.get_game!(game.id) end
    end

    test "change_game/1 returns a game changeset" do
      game = game_fixture()
      assert %Ecto.Changeset{} = Games.change_game(game)
    end
  end
end

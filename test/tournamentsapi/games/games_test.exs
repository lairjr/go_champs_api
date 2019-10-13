defmodule TournamentsApi.GamesTest do
  use TournamentsApi.DataCase

  alias TournamentsApi.Helpers.PhaseHelpers
  alias TournamentsApi.Games

  describe "games" do
    alias TournamentsApi.Games.Game

    @valid_attrs %{
      away_score: 10,
      datetime: "2019-08-25T16:59:27.116Z",
      home_score: 20,
      location: "some location"
    }
    @update_attrs %{
      away_score: 20,
      datetime: "2019-08-25T16:59:27.116Z",
      home_score: 30,
      location: "another location"
    }
    @invalid_attrs %{phase_id: nil}

    def game_fixture(attrs \\ %{}) do
      {:ok, game} =
        attrs
        |> Enum.into(@valid_attrs)
        |> PhaseHelpers.map_phase_id()
        |> Games.create_game()

      game
    end

    test "get_game!/1 returns the game with given id" do
      game = game_fixture()

      result_game = Games.get_game!(game.id)

      assert result_game.id == game.id
    end

    test "create_game/1 with valid data creates a game" do
      attrs = PhaseHelpers.map_phase_id(@valid_attrs)

      assert {:ok, %Game{} = game} = Games.create_game(attrs)
    end

    test "create_game/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Games.create_game(@invalid_attrs)
    end

    test "update_game/2 with valid data updates the game" do
      game = game_fixture()

      attrs = Map.merge(@update_attrs, %{phase_id: game.phase_id})

      {:ok, %Game{} = updated_game} = Games.update_game(game, attrs)

      assert updated_game.away_score == attrs.away_score
      assert updated_game.home_score == attrs.home_score
      assert updated_game.location == attrs.location
    end

    test "update_game/2 with invalid data returns error changeset" do
      game = game_fixture()

      assert {:error, %Ecto.Changeset{}} = Games.update_game(game, @invalid_attrs)

      result_game = Games.get_game!(game.id)

      assert result_game.id == game.id
    end

    test "delete_game/1 deletes the game" do
      game = game_fixture()
      assert {:ok, %Game{}} = Games.delete_game(game)

      assert_raise Ecto.NoResultsError, fn ->
        Games.get_game!(game.id)
      end
    end

    test "change_game/1 returns a game changeset" do
      game = game_fixture()
      assert %Ecto.Changeset{} = Games.change_game(game)
    end
  end
end

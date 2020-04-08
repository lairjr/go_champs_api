defmodule GoChampsApi.DrawsTest do
  use GoChampsApi.DataCase

  alias GoChampsApi.Draws
  alias GoChampsApi.Helpers.PhaseHelpers

  describe "draws" do
    alias GoChampsApi.Draws.Draw

    @valid_attrs %{
      title: "some title",
      matches: [
        %{
          first_team_placeholder: "some-first-team-placeholder",
          info: "some info",
          name: "some name",
          second_team_placeholder: "some-second-team-placeholder"
        }
      ]
    }
    @update_attrs %{
      title: "some updated title",
      matches: [
        %{
          first_team_placeholder: "some-updated-first-team-placeholder",
          info: "some updated info",
          name: "some updated name",
          second_team_placeholder: "some-updated-second-team-placeholder"
        }
      ]
    }
    @invalid_attrs %{title: nil, matches: nil}

    def draw_fixture(attrs \\ %{}) do
      {:ok, draw} =
        attrs
        |> Enum.into(@valid_attrs)
        |> PhaseHelpers.map_phase_id()
        |> Draws.create_draw()

      draw
    end

    test "get_draw!/1 returns the draw with given id" do
      draw = draw_fixture()

      assert Draws.get_draw!(draw.id) ==
               draw
    end

    test "create_draw/1 with valid data creates a draw" do
      attrs = PhaseHelpers.map_phase_id(@valid_attrs)
      assert {:ok, %Draw{} = draw} = Draws.create_draw(attrs)

      [match] = draw.matches
      assert draw.order == 1
      assert draw.title == "some title"
      assert match.first_team_placeholder == "some-first-team-placeholder"
      assert match.info == "some info"
      assert match.name == "some name"
      assert match.second_team_placeholder == "some-second-team-placeholder"
    end

    test "create_draw/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Draws.create_draw(@invalid_attrs)
    end

    test "create_draw/1 select order for second item" do
      attrs = PhaseHelpers.map_phase_id(@valid_attrs)

      assert {:ok, %Draw{} = first_draw} = Draws.create_draw(attrs)

      assert {:ok, %Draw{} = second_draw} = Draws.create_draw(attrs)

      assert first_draw.order == 1
      assert second_draw.order == 2
    end

    test "update_draw/2 with valid data updates the draw" do
      draw = draw_fixture()

      assert {:ok, %Draw{} = draw} = Draws.update_draw(draw, @update_attrs)

      [match] = draw.matches
      assert draw.title == "some updated title"
      assert match.first_team_placeholder == "some-updated-first-team-placeholder"
      assert match.info == "some updated info"
      assert match.name == "some updated name"
      assert match.second_team_placeholder == "some-updated-second-team-placeholder"
    end

    test "update_draw/2 with invalid data returns error changeset" do
      draw = draw_fixture()
      assert {:error, %Ecto.Changeset{}} = Draws.update_draw(draw, @invalid_attrs)

      assert draw ==
               Draws.get_draw!(draw.id)
    end

    test "update_draws/2 with valid data updates the phase" do
      attrs = PhaseHelpers.map_phase_id(@valid_attrs)

      {:ok, %Draw{} = first_draw} = Draws.create_draw(attrs)
      {:ok, %Draw{} = second_draw} = Draws.create_draw(attrs)

      first_updated_draw = %{
        "id" => first_draw.id,
        "title" => "some first updated title"
      }

      second_updated_draw = %{
        "id" => second_draw.id,
        "title" => "some second updated title"
      }

      {:ok, batch_results} = Draws.update_draws([first_updated_draw, second_updated_draw])

      assert batch_results[first_draw.id].id == first_draw.id
      assert batch_results[first_draw.id].title == "some first updated title"
      assert batch_results[second_draw.id].id == second_draw.id
      assert batch_results[second_draw.id].title == "some second updated title"
    end

    test "delete_draw/1 deletes the draw" do
      draw = draw_fixture()
      assert {:ok, %Draw{}} = Draws.delete_draw(draw)

      assert_raise Ecto.NoResultsError, fn ->
        Draws.get_draw!(draw.id)
      end
    end

    test "change_draw/1 returns a draw changeset" do
      draw = draw_fixture()
      assert %Ecto.Changeset{} = Draws.change_draw(draw)
    end
  end
end

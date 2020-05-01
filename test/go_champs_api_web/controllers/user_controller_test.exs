defmodule GoChampsApiWeb.UserControllerTest do
  use GoChampsApiWeb.ConnCase

  alias GoChampsApi.Accounts

  @create_attrs %{
    email: "some@email.com",
    password: "some password",
    username: "someuser"
  }
  @update_attrs %{
    email: "some@email.com",
    password: "some other password",
    username: "someuser"
  }
  @invalid_attrs %{email: nil, password: nil}

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, Routes.v1_user_path(conn, :create), user: @create_attrs)
      assert %{"email" => email} = json_response(conn, 201)["data"]

      conn = post(conn, Routes.v1_user_path(conn, :signin), @create_attrs)

      %{"email" => result_email, "token" => result_token, "username" => result_username} =
        json_response(conn, 200)["data"]

      assert result_email == "some@email.com"
      assert result_token != nil
      assert result_username == "someuser"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.v1_user_path(conn, :create), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{
      conn: conn
    } do
      conn = patch(conn, Routes.v1_user_path(conn, :update), %{user: @update_attrs})
      %{"email" => result_email} = json_response(conn, 200)["data"]
      assert result_email == "some@email.com"

      conn = post(conn, Routes.v1_user_path(conn, :signin), @update_attrs)

      %{"email" => result_email, "token" => result_token, "username" => result_username} =
        json_response(conn, 200)["data"]

      assert result_email == "some@email.com"
      assert result_token != nil
      assert result_username == "someuser"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = patch(conn, Routes.v1_user_path(conn, :update), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end

defmodule GoChampsApiWeb.UserControllerTest do
  use GoChampsApiWeb.ConnCase

  alias GoChampsApi.Accounts

  @create_attrs %{
    email: "someuser@email.com",
    password: "some password",
    username: "someusername"
  }
  @update_attrs %{
    email: "someuser@email.com",
    password: "some other password",
    username: "someusername"
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

      assert result_email == "someuser@email.com"
      assert result_token != nil
      assert result_username == "someusername"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.v1_user_path(conn, :create), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    @tag :authenticated
    test "renders user when data is valid", %{
      conn: conn
    } do
      conn = patch(conn, Routes.v1_user_path(conn, :update), %{user: @update_attrs})
      %{"email" => result_email} = json_response(conn, 200)["data"]
      assert result_email == "someuser@email.com"

      conn = post(conn, Routes.v1_user_path(conn, :signin), @update_attrs)

      %{"email" => result_email, "token" => result_token, "username" => result_username} =
        json_response(conn, 200)["data"]

      assert result_email == "someuser@email.com"
      assert result_token != nil
      assert result_username == "someusername"
    end

    @tag :authenticated
    test "renders errors when data is invalid", %{conn: conn} do
      conn = patch(conn, Routes.v1_user_path(conn, :update), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "show user" do
    @tag :authenticated
    test "renders user when data associated with token", %{
      conn: conn
    } do
      conn = get(conn, Routes.v1_user_path(conn, :show, username: "someuser"))

      assert %{
               "email" => "some@email.com",
               "username" => "someuser",
               "organizations" => []
             } = json_response(conn, 200)["data"]
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end

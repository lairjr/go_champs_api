defmodule GoChampsApiWeb.UserControllerTest do
  use GoChampsApiWeb.ConnCase

  @create_attrs %{
    email: "some@email.com",
    password: "some password"
  }
  @invalid_attrs %{email: nil, password: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, Routes.v1_user_path(conn, :create), user: @create_attrs)
      assert %{"email" => email} = json_response(conn, 201)["data"]

      conn = post(conn, Routes.v1_user_path(conn, :signin), @create_attrs)

      %{"email" => result_email, "token" => result_token} = json_response(conn, 200)["data"]

      assert result_email == "some@email.com"
      assert result_token != nil
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.v1_user_path(conn, :create), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end

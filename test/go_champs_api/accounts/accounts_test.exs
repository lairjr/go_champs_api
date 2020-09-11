defmodule GoChampsApi.AccountsTest do
  use GoChampsApi.DataCase

  alias GoChampsApi.Accounts

  describe "users" do
    alias GoChampsApi.Accounts.User

    @valid_attrs %{
      email: "some@email.com",
      password: "somepassword",
      username: "someuser"
    }
    @update_attrs %{
      email: "someupdated@email.com",
      password: "someupdatedpassword",
      username: "someupdateduser"
    }
    @valid_facebook_attrs %{
      email: "some@email.com",
      facebook_id: "some-facebook-id",
      username: "someuser"
    }
    @invalid_attrs %{email: nil, password: nil, username: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      [result_user] = Accounts.list_users()

      assert result_user.id == user.id
      assert result_user.email == user.email
      assert result_user.username == user.username
      assert result_user.encrypted_password == user.encrypted_password
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()

      result_user = Accounts.get_user!(user.id)

      assert result_user.id == user.id
      assert result_user.email == user.email
      assert result_user.username == user.username
      assert result_user.encrypted_password == user.encrypted_password
    end

    test "get_by_email!/1 returns the user with given id" do
      user = user_fixture()

      assert {:ok, %User{} = result_user} = Accounts.get_by_email!("some@email.com")

      assert result_user.id == user.id
      assert result_user.email == user.email
      assert result_user.username == user.username
      assert result_user.encrypted_password == user.encrypted_password
    end

    test "get_by_username!/1 returns the user with given id" do
      user = user_fixture()

      assert {:ok, %User{} = result_user} = Accounts.get_by_username!("someuser")

      assert result_user.id == user.id
      assert result_user.email == user.email
      assert result_user.username == user.username
      assert result_user.encrypted_password == user.encrypted_password
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.email == "some@email.com"
      assert user.password == "somepassword"
      assert user.username == "someuser"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "create_user_with_facebook/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user_with_facebook(@valid_facebook_attrs)
      assert user.email == "some@email.com"
      assert user.facebook_id == "some-facebook-id"
      assert user.username == "someuser"
    end

    test "create_user_with_facebook/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user_with_facebook(@invalid_attrs)
    end

    test "reset_user/2 with valid data update password" do
      user = user_fixture()
      {:ok, %User{} = recovery_user} = Accounts.update_recovery_token(user)

      valid_attrs = %{
        password: "someotherpassword",
        recovery_token: recovery_user.recovery_token
      }

      {:ok, %User{} = reset_user} = Accounts.reset_password(recovery_user, valid_attrs)
      assert reset_user.password == "someotherpassword"
      assert reset_user.recovery_token == nil
    end

    test "reset_user/2 with invalid recovery token data update password" do
      user = user_fixture()
      {:ok, %User{} = recovery_user} = Accounts.update_recovery_token(user)

      invalid_attrs = %{
        password: "someotherpassword",
        recovery_token: "some dumb token"
      }

      assert {:error, changeset} = Accounts.reset_password(recovery_user, invalid_attrs)
      assert changeset.errors == [recovery_token: {"Invalid recovery token", []}]
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.email == "someupdated@email.com"
      assert user.password == "someupdatedpassword"
      assert user.username == "someupdateduser"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()

      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
    end

    test "update_recovery_token/1 with valid data" do
      user = user_fixture()
      assert {:ok, %User{} = result_user} = Accounts.update_recovery_token(user)

      assert result_user.recovery_token != nil
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end

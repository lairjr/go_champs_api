defmodule GoChampsApi.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias GoChampsApi.Repo

  alias GoChampsApi.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Gets a single user by email.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!("someuser@email.com")
      %User{}

      iex> get_user!("somemissinguser@email.com")
      ** (Ecto.NoResultsError)

  """
  def get_by_email!(email) do
    case Repo.get_by(User, email: email) do
      nil ->
        {:error, :not_found}

      user ->
        {:ok, user}
    end
  end

  @doc """
  Gets a single user by username.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!("someuser")
      %User{}

      iex> get_user!("somemissinguser")
      ** (Ecto.NoResultsError)

  """
  def get_by_username!(username) do
    case Repo.get_by(User, username: username) do
      nil ->
        {:error, :not_found}

      user ->
        {:ok, user}
    end
  end

  @doc """
  Gets a single user by facebook id.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!("someuser")
      %User{}

      iex> get_user!("somemissinguser")
      ** (Ecto.NoResultsError)

  """
  def get_by_facebook_id!(facebook_id) do
    case Repo.get_by(User, facebook_id: facebook_id) do
      nil ->
        {:error, :not_found}

      user ->
        {:ok, user}
    end
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a user with facebook data.

  ## Examples

      iex> create_user_with_facebook(%{field: value})
      {:ok, %User{}}

      iex> create_user_with_facebook(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_with_facebook(attrs \\ %{}) do
    %User{}
    |> User.facebook_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Reset user password.

  ## Examples

      iex> reset_password(user, %{field: new_value})
      {:ok, %User{}}

      iex> reset_password(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def reset_password(%User{} = user, attrs) do
    user
    |> User.reset_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Updates a user recovery token.

  ## Examples

      iex> update_recovery_token(user)
      {:ok, %User{}}

      iex> update_recovery_token(user)
      {:error, %Ecto.Changeset{}}

  """
  def update_recovery_token(%User{} = user) do
    user
    |> User.recovery_changeset()
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end
end

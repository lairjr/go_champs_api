defmodule GoChampsApi.Accounts.User do
  use Ecto.Schema
  use GoChampsApi.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :username, :string
    field :encrypted_password, :string
    field :password, :string, virtual: true
    field :recovery_token, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password, :username, :recovery_token])
    |> validate_required([:email, :password, :username])
    |> validate_format(:email, ~r/^[A-Za-z0-9._-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/)
    |> validate_format(:username, ~r/^([A-Za-z0-9]+(?:.-[a-z0-9]+)*){4,20}$/)
    |> validate_length(:password, min: 6)
    |> unique_constraint(:email)
    |> unique_constraint(:username)
    |> put_hashed_password
  end

  defp put_hashed_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :encrypted_password, Bcrypt.hash_pwd_salt(password))

      _ ->
        changeset
    end
  end
end

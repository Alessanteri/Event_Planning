defmodule EventPlanning.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias EventPlanning.Repo

  alias EventPlanning.Accounts.User
  alias EventPlanning.IAE.Event

  @doc """
  Returns the list of users.
  """
  def list_users do
    User
    |> Repo.all()
  end

  @doc """
  Gets a single user.
  Raises `Ecto.NoResultsError` if the User does not exist.
  """
  def get_user!(id) do
    User
    |> Repo.get!(id)
  end

  @doc """
  Creates a user.
  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.
  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Ecto.Changeset.cast_assoc(:event, with: &Event.changeset/2)
    |> Repo.update()
  end

  @doc """
  Deletes a user.
  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def authenticate_by_email_password(email, password) do
    query = from(u in User, where: u.email == ^email)

    case Repo.one(query) do
      %User{} = user -> {:ok, user}
      nil -> {:error, :unauthorized}
    end
  end

  def get_by_email(email) do
    case Repo.get_by(User, email: email) do
      nil ->
        {:error, :not_found}

      user ->
        {:ok, user}
    end
  end
end

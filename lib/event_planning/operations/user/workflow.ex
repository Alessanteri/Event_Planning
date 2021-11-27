defmodule EventPlanning.Operation.User.Workflow do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias EventPlanning.Repo

  alias EventPlanning.Models.User
  alias EventPlanning.Models.Event

  @password "DgB4PPljWY"

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

  def authenticate_by_email_password(email, password) do
    if password == @password do
      query = from(u in User, where: u.email == ^email)

      case Repo.one(query) do
        %User{} = user -> {:ok, user}
        nil -> {:error, :unauthorized}
      end
    else
      {:error, :unauthorized}
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

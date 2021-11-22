defmodule EventPlanningWeb.UserController do
  use EventPlanningWeb, :controller

  alias EventPlanning.Accounts
  alias EventPlanning.Accounts.User
  alias EventPlanning.Repo

  # plug(:assign_user)
  plug(:authorize_user)

  def index(conn, _params) do
    if Ability.can?(%User{}, :read, get_session(conn, :current_user)) do
      users = Accounts.list_users()
      user = get_session(conn, :current_user)
      render(conn, "index.html", users: users, user: user)
    else
      if get_session(conn, :current_user) do
        redirect(conn,
          to: Routes.user_event_path(conn, :my_schedule, get_session(conn, :current_user).id)
        )
      else
        conn
        |> put_flash(:error, "Invalid user!")
        |> redirect(to: Routes.session_path(conn, :new))
        |> halt
      end
    end
  end

  def show(conn, %{"id" => id}) do
    if Ability.can?(%User{}, :read, get_session(conn, :current_user)) or
         String.to_integer(id) == get_session(conn, :current_user).id do
      user = Accounts.get_user!(id)
      render(conn, "show.html", user: user)
    else
      if get_session(conn, :current_user) do
        redirect(conn,
          to: Routes.user_event_path(conn, :my_schedule, get_session(conn, :current_user).id)
        )
      else
        conn
        |> put_flash(:error, "Invalid user!")
        |> redirect(to: Routes.session_path(conn, :new))
        |> halt
      end
    end
  end

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    user_role = Accounts.get_user!(get_session(conn, :current_user).id)
    render(conn, "new.html", changeset: changeset, user_role: user_role)
  end

  def edit(conn, %{"id" => id}) do
    if Ability.can?(%User{}, :read, get_session(conn, :current_user)) or
         String.to_integer(id) == get_session(conn, :current_user).id do
      user = Accounts.get_user!(id)
      user_role = Accounts.get_user!(get_session(conn, :current_user).id)
      changeset = Accounts.change_user(user)
      render(conn, "edit.html", user: user, changeset: changeset, user_role: user_role)
    else
      if get_session(conn, :current_user) do
        redirect(conn,
          to: Routes.user_event_path(conn, :my_schedule, get_session(conn, :current_user).id)
        )
      else
        conn
        |> put_flash(:error, "Invalid user!")
        |> redirect(to: Routes.session_path(conn, :new))
        |> halt
      end
    end
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: Routes.user_path(conn, :index, get_session(conn, :current_user)))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    if Ability.can?(%User{}, :read, get_session(conn, :current_user)) or
         String.to_integer(id) == get_session(conn, :current_user).id do
      user = Accounts.get_user!(id)

      case Accounts.update_user(user, user_params) do
        {:ok, user} ->
          conn
          |> put_flash(:info, "Event updated successfully.")
          |> redirect(to: Routes.user_path(conn, :show, user.id))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edit.html", user: user, changeset: changeset)
      end
    else
      if get_session(conn, :current_user) do
        redirect(conn,
          to: Routes.user_event_path(conn, :my_schedule, get_session(conn, :current_user).id)
        )
      else
        conn
        |> put_flash(:error, "Invalid user!")
        |> redirect(to: Routes.session_path(conn, :new))
        |> halt
      end
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    {:ok, _user} = Accounts.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: Routes.user_path(conn, :index, get_session(conn, :current_user)))
  end

  defp assign_user(conn, _opts) do
    case conn.params do
      %{"user_id" => user_id} ->
        case Repo.get(Accounts.User, user_id) do
          nil -> invalid_user(conn)
          user -> assign(conn, :user, user)
        end

      _ ->
        invalid_user(conn)
    end
  end

  defp invalid_user(conn) do
    conn
    |> put_flash(:error, "Invalid user!")
    |> redirect(to: Routes.session_path(conn, :new))
    |> halt
  end

  defp authorize_user(conn, _opts) do
    user = get_session(conn, :current_user)

    if user do
      conn
    else
      conn
      |> put_flash(:error, "You are not authorized to modify that post!")
      |> redirect(to: Routes.session_path(conn, :new))
      |> halt()
    end
  end
end

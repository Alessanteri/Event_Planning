defmodule EventPlanning.DataCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias EventPlanning.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import EventPlanning.DataCase
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(EventPlanning.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(EventPlanning.Repo, {:shared, self()})
    end

    :ok
  end

  @doc """
  A helper that transforms changeset errors into a map of messages.

      assert {:error, changeset} = Accounts.create_user(%{password: "short"})
      assert "password is too short" in errors_on(changeset).password
      assert %{password: ["password is too short"]} = errors_on(changeset)

  """
  def errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end
end

defmodule EventPlanningWeb.ConnCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      import Plug.Conn
      import Phoenix.ConnTest
      import EventPlanningWeb.ConnCase

      alias EventPlanningWeb.Router.Helpers, as: Routes

      @endpoint EventPlanningWeb.Endpoint
      def session_conn() do
        build_conn() |> Plug.Test.init_test_session(%{})
      end
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(EventPlanning.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(EventPlanning.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end

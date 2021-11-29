defmodule EventPlanningWeb.ChannelCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with channels
      import Phoenix.ChannelTest
      import EventPlanningWeb.ChannelCase

      # The default endpoint for testing
      @endpoint EventPlanningWeb.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(EventPlanning.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(EventPlanning.Repo, {:shared, self()})
    end

    :ok
  end
end

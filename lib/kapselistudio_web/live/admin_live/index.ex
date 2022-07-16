defmodule KapselistudioWeb.AdminLive.Index do
  use KapselistudioWeb, :live_view

  alias Kapselistudio.Accounts

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :users, list_users())}
  end

  defp list_users() do
    Accounts.list_users()
  end
end

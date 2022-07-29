defmodule KapselistudioWeb.AdminLive.Index do
  use KapselistudioWeb, :live_view

  alias Kapselistudio.Accounts
  alias Kapselistudio.Accounts.User
  import KapselistudioWeb.UI

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :users, list_users())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Lisää käyttäjä")
    |> assign(:user, %User{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Kaikki käyttäjät")
    |> assign(:user, nil)
  end

  defp list_users() do
    Accounts.list_users()
  end
end

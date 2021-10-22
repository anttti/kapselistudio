defmodule KapselistudioWeb.EpisodeLive.Index do
  use KapselistudioWeb, :live_view

  alias Kapselistudio.Media
  alias Kapselistudio.Media.Episode

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :episodes, list_episodes())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Episode")
    |> assign(:episode, Media.get_episode!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Episode")
    |> assign(:episode, %Episode{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Episodes")
    |> assign(:episode, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    episode = Media.get_episode!(id)
    {:ok, _} = Media.delete_episode(episode)

    {:noreply, assign(socket, :episodes, list_episodes())}
  end

  defp list_episodes do
    Media.list_episodes()
  end
end

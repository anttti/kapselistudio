defmodule KapselistudioWeb.PodcastLive.Index do
  use KapselistudioWeb, :live_view

  alias Kapselistudio.Media
  alias Kapselistudio.Media.Podcast

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :podcasts, list_podcasts())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Podcast")
    |> assign(:podcast, Media.get_podcast!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Podcast")
    |> assign(:podcast, %Podcast{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Podcasts")
    |> assign(:podcast, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    podcast = Media.get_podcast!(id)
    {:ok, _} = Media.delete_podcast(podcast)

    {:noreply, assign(socket, :podcasts, list_podcasts())}
  end

  defp list_podcasts do
    Media.list_podcasts()
  end
end

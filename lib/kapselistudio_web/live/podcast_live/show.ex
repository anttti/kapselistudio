defmodule KapselistudioWeb.PodcastLive.Show do
  use KapselistudioWeb, :live_view

  alias Kapselistudio.Media
  alias Kapselistudio.Media.Episode

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    mount_with_id(id, socket)
  end

  def mount(%{"podcast_id" => id}, _session, socket) do
    mount_with_id(id, socket)
  end

  defp mount_with_id(id, socket) do
    {:ok, assign(socket, :podcast, Media.get_podcast!(id))}
  end

  @impl true
  def handle_params(params, _, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :show, %{"id" => id}) do
    socket
    |> assign(:page_title, "Näytä podcast")
    |> assign(:podcast, Media.get_podcast!(id))
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Muokkaa podcastia")
    |> assign(:podcast, Media.get_podcast!(id))
  end

  defp apply_action(socket, :new_episode, %{"podcast_id" => podcast_id}) do
    socket
    |> assign(:page_title, "Uusi jakso")
    |> assign(:episode, %Episode{podcast_id: podcast_id})
  end
end

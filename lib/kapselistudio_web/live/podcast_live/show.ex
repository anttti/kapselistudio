defmodule KapselistudioWeb.PodcastLive.Show do
  use KapselistudioWeb, :live_view

  alias Kapselistudio.Media
  alias Kapselistudio.Media.Episode

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok, socket |> assign(:podcast, Media.get_podcast!(id))}
  end

  def mount(%{"podcast_id" => id}, _session, socket) do
    {:ok, socket |> assign(:podcast, Media.get_podcast!(id))}
  end

  @impl true
  def handle_params(params, _, socket) do
    IO.puts("action: #{socket.assigns.live_action}")
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

  defp apply_action(socket, :edit_episode, %{"episode_id" => episode_id}) do
    socket
    |> assign(:page_title, "Muokkaa jaksoa")
    |> assign(:episode, Media.get_episode!(episode_id))
  end

  defp apply_action(socket, :new_episode, %{"podcast_id" => podcast_id}) do
    socket
    |> assign(:page_title, "Uusi jakso")
    |> assign(:episode, %Episode{podcast_id: podcast_id})
  end
end

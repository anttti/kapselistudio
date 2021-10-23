defmodule KapselistudioWeb.EpisodeLive.Show do
  use KapselistudioWeb, :live_view

  alias Kapselistudio.Media

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :show, %{"id" => id}) do
    socket
    |> assign(:page_title, "Jakson tiedot")
    |> assign(:episode, Media.get_episode!(id))
  end

  defp apply_action(socket, :edit_episode, %{"episode_id" => episode_id}) do
    socket
    |> assign(:page_title, "Muokkaa jaksoa")
    |> assign(:episode, Media.get_episode!(episode_id))
  end
end

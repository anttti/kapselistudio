defmodule KapselistudioWeb.PodcastLive.Show do
  use KapselistudioWeb, :live_view

  alias Kapselistudio.Media

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:podcast, Media.get_podcast!(id))}
  end

  defp page_title(:show), do: "Show Podcast"
  defp page_title(:edit), do: "Edit Podcast"
end

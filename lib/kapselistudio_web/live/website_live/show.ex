defmodule KapselistudioWeb.WebsiteLive.Show do
  use KapselistudioWeb, :public_live_view

  alias Kapselistudio.Media

  import KapselistudioWeb.WebsiteLive.HeaderComponent

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    mount_with_id(id, socket)
  end

  def mount(%{"podcast_id" => id}, _session, socket) do
    mount_with_id(id, socket)
  end

  defp mount_with_id(id, socket) do
    {:ok, assign(socket, :podcast, Media.get_podcast_with_published_episodes!(id))}
  end
end

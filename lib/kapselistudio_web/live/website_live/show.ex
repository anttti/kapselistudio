defmodule KapselistudioWeb.WebsiteLive.Show do
  use KapselistudioWeb, :public_live_view

  alias Kapselistudio.Media

  import KapselistudioWeb.WebsiteLive.HeaderComponent

  @impl true
  def mount(_params, _session, socket) do
    %URI{host: host} = socket.host_uri
    subdomain = Kapselistudio.Origin.get_subdomain(host)

    {:ok, assign(socket, :podcast, Media.get_podcast_for_slug_with_episodes!(subdomain))}
  end
end

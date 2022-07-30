defmodule KapselistudioWeb.Live.PlayerLive do
  use KapselistudioWeb, :public_live_view

  def mount(_params, _session, socket) do
    {:ok, socket, layout: false}
  end

  def render(assigns) do
    ~H"""
    <div class="p-4 bg-gray-200 h-12">
      <audio
        class="w-full"
        controls
        src="https://dts.podtrac.com/redirect.mp4/rarelyneeded.com/retropelipodcast/Retropelipodcast_4.mp3"
      />
    </div>
    """
  end
end

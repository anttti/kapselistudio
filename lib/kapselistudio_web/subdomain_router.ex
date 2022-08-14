defmodule KapselistudioWeb.SubdomainRouter do
  use KapselistudioWeb, :router

  pipeline :browser do
    plug KapselistudioWeb.Plugs.ValidateSlug
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {KapselistudioWeb.LayoutView, :public_root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", KapselistudioWeb do
    pipe_through :browser

    live "/", WebsiteLive.ShowPodcast, :show_podcast
    live "/all", WebsiteLive.ShowAll, :show_all_episodes
    live "/:episode_number", WebsiteLive.ShowEpisode, :show_episode
  end
end

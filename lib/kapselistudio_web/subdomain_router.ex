defmodule KapselistudioWeb.SubdomainRouter do
  use KapselistudioWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
  end

  scope "/", KapselistudioWeb do
    # Use the default browser stack
    pipe_through :browser

    get "/", PageController, :index
  end
end

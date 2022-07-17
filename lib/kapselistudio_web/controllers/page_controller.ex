defmodule KapselistudioWeb.PageController do
  use KapselistudioWeb, :controller

  def index(conn, _params) do
    text(conn, "Subdomain home for #{conn.private[:subdomain]}")
  end
end

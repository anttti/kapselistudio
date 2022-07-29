defmodule KapselistudioWeb.Plugs.Subdomain do
  import Plug.Conn

  def init(default), do: default

  def call(conn, router) do
    case Kapselistudio.Origin.get_subdomain(conn.host) do
      subdomain when byte_size(subdomain) > 0 ->
        podcast = Kapselistudio.Media.get_podcast_for_slug(subdomain)
        if podcast == nil, do: halt(conn)

        conn
        |> put_private(:subdomain, subdomain)
        |> router.call(router.init({}))
        |> halt

      _ ->
        conn
    end
  end
end

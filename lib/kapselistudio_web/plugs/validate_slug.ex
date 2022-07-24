# A plug that checks that the subdomain matches a podcast in the DB

defmodule KapselistudioWeb.Plugs.ValidateSlug do
  import Plug.Conn

  alias Kapselistudio.Media.Podcast

  def init(default), do: default

  def call(conn, _) do
    subdomain = Kapselistudio.Origin.get_subdomain(conn.host)
    IO.inspect("Validating slug: #{subdomain}")

    case Kapselistudio.Media.get_podcast_for_slug(subdomain) do
      %Podcast{} ->
        conn

      _ ->
        conn
        |> send_resp(404, [])
        |> halt()
    end
  end
end

defmodule Kapselistudio.Origin do
  def check_origin(%URI{} = _origin) do
    true
    # podcast = origin.authority |> get_subdomain() |> Kapselistudio.Media.get_podcast_for_slug()
    # IO.inspect(podcast)
    # podcast != nil
    # origin.authority in ["a.kapselistudio.local"]
  end

  def get_subdomain(host) do
    root_host = KapselistudioWeb.Endpoint.config(:url)[:host]
    String.replace(host, ~r/.?#{root_host}/, "") |> String.replace(":4000", "")
  end
end

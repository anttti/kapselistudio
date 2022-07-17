defmodule Kapselistudio.Origin do
  def check_origin(%URI{} = _origin) do
    true
  end

  def get_subdomain(host) do
    root_host = KapselistudioWeb.Endpoint.config(:url)[:host]
    String.replace(host, ~r/.?#{root_host}/, "") |> String.replace(":4000", "")
  end
end

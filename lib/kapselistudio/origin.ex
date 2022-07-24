defmodule Kapselistudio.Origin do
  def check_origin(%URI{} = _origin) do
    true
  end

  def get_subdomain(host) do
    root_host = KapselistudioWeb.Endpoint.config(:url)[:host]

    IO.inspect(
      "Getting subdomain, root_host: #{root_host}, parsed: #{String.replace(host, ~r/.?#{root_host}/, "")}"
    )

    String.replace(host, ~r/.?#{root_host}/, "") |> String.replace(":4000", "")
  end
end

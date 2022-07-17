defmodule KapselistudioWeb.Plugs.Subdomain do
  import Plug.Conn

  def init(default), do: default

  def call(conn, router) do
    case get_subdomain(conn.host) do
      subdomain when byte_size(subdomain) > 0 ->
        conn
        |> put_private(:subdomain, subdomain)
        |> router.call(router.init({}))
        |> halt

      _ ->
        conn
    end
  end

  defp get_subdomain(host) do
    root_host = KapselistudioWeb.Endpoint.config(:url)[:host]
    String.replace(host, ~r/.?#{root_host}/, "")
  end
end

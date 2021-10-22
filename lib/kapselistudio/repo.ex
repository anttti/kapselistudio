defmodule Kapselistudio.Repo do
  use Ecto.Repo,
    otp_app: :kapselistudio,
    adapter: Ecto.Adapters.Postgres
end

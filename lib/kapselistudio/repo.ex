defmodule Kapselistudio.Repo do
  # use Ecto.Repo,
  #   otp_app: :kapselistudio,
  #   adapter: Ecto.Adapters.Postgres
  use Ecto.Repo,
    otp_app: :kapselistudio,
    adapter: Ecto.Adapters.SQLite3
end

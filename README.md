# Kapselistudio

To start:

- Run the development db with `docker compose up`
- Install dependencies with `mix deps.get`
- Create and migrate your database with `mix ecto.setup`
- Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Deploying to Gigalixir

- `git remote add gigalixir https://git.gigalixir.com/kapselistudio.git/`
- `git push gigalixir`

### Running migrations in Gigalixir

- `gigalixir run mix ecto.migrate`

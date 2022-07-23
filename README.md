# Kapselistudio

To start:

- Add `127.0.0.1 kapselistudio.local` to `/etc/hosts`
  - Add also subdomains if necessary, e.g. `127.0.0.1 kapselistudio.local webbidevaus.kapselistudio.local`
- Run the development db with `docker compose up`
- Install dependencies with `mix deps.get`
- Create and migrate your database with `mix ecto.setup`
- Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`kapselistudio.local:4000`](http://kapselistudio.local:4000) from your browser.

### Erlang & Elixir versions

Set in `.tool-versions` file, currently Elixir 1.13 and Erlang 25.

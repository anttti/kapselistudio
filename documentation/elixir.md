# Random notes about Elixir, Erland, ASDF, mix and the bunch

## Installing the latest Elixir & Erlang

- `asdf install elixir latest`
- `asdf install erlang latest`

## Setting Elixir & Erlang versions

### Globally

- `asdf global elixir 1.13.3-otp-24`

### Locally

- Edit `.tool-versions` file

## Determining outdated deps

- `mix hex.outdated`

## Installing deps

- `mix deps.get`

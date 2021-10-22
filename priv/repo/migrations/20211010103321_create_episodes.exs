defmodule Kapselistudio.Repo.Migrations.CreateEpisodes do
  use Ecto.Migration

  def change do
    create table(:episodes) do
      add :number, :integer
      add :url, :string
      add :duration, :integer
      add :title, :string
      add :shownotes, :string

      timestamps()
    end
  end
end

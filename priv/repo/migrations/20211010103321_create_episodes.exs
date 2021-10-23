defmodule Kapselistudio.Repo.Migrations.CreateEpisodes do
  use Ecto.Migration

  def change do
    create table(:episodes) do
      add :number, :integer
      add :url, :text
      add :duration, :integer
      add :title, :text
      add :shownotes, :text

      timestamps()
    end
  end
end

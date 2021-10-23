defmodule Kapselistudio.Repo.Migrations.CreateEpisodes do
  use Ecto.Migration

  def change do
    create table(:episodes) do
      add :number, :integer
      add :url, :text
      add :duration, :integer
      add :title, :text
      add :shownotes, :text
      add :status, :string
      add :published_at, :utc_datetime

      timestamps()
    end
  end
end

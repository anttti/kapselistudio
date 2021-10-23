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

      timestamps()
    end
  end
end

defmodule Kapselistudio.Repo.Migrations.AddEpisodeDescription do
  use Ecto.Migration

  def change do
    alter table(:episodes) do
      add :description, :text
    end
  end
end

defmodule Kapselistudio.Repo.Migrations.AddEpisodeGuid do
  use Ecto.Migration

  def change do
    alter table(:episodes) do
      add :guid, :text
    end
  end
end

defmodule Kapselistudio.Repo.Migrations.RemoveAuthor do
  use Ecto.Migration

  def change do
    alter table(:podcasts) do
      remove :author
    end
  end
end

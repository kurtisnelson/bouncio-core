defmodule Bouncer.Repo.Migrations.CreateApplications do
  use Ecto.Migration

  def change do
    create table(:apps, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("uuid_generate_v4()")
      add :name,:string

      timestamps
    end
    execute "INSERT INTO apps (id, name, inserted_at, updated_at) VALUES ('00000000-0000-0000-0000-000000000000', 'internal', NOW(), NOW());"
  end
end

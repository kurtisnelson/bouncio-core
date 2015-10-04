defmodule Bouncio.Repo.Migrations.CreateSessions do
  use Ecto.Migration

  def change do
    create table(:sessions, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("uuid_generate_v4()")
      add :refresh_token, :string
      add :access_token, :string
      add :expires_at, :datetime
      add :user_id, references(:users, type: :binary_id)
      timestamps
    end
    create index(:sessions, [:access_token])
  end
end

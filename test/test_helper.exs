ExUnit.start
Faker.start
Mix.Task.run "ecto.drop", ["--quiet"]
Mix.Task.run "ecto.create", ["--quiet"]
Mix.Task.run "ecto.migrate", ["--quiet"]
Ecto.Adapters.SQL.begin_test_transaction(Bouncio.Repo)

defmodule Blacksmith.Config do
  def save(repo, map) do
    repo.insert(map)
  end

  def save_all(repo, list) do
    Enum.map(list, &repo.insert/1)
  end
end

defmodule Forge do
  use Blacksmith
  alias Bouncio.User
  @save_one_function &Blacksmith.Config.save/2
  @save_all_function &Blacksmith.Config.save_all/2

  register :user,
    __struct__: User,
    email: "kurt@example.com",
    password: Faker.Lorem.characters(8),
    app_id: Bouncio.App.internal_id
end

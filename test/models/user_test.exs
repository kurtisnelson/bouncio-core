defmodule Bouncio.UserTest do
  use Bouncio.ModelCase

  alias Bouncio.User

  @valid_attrs %{app_id: Bouncio.App.internal_id, email: "kurt@example.com", password: "12345678"}
  @invalid_attrs %{password: "1234"}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "disallows duplicate emails in same app" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert {:ok, _} = Repo.insert(changeset)
    assert {:error, _} = Repo.insert(changeset)
  end

  test "allows dupe emails across app" do
    app1 = Repo.insert!(Bouncio.App.changeset(%Bouncio.App{}, %{name: "app1"}))
    app2 = Repo.insert!(Bouncio.App.changeset(%Bouncio.App{}, %{name: "app2"}))
    changeset = User.changeset(%User{}, %{email: "kurt@example.com", app_id: app1.id, password: "12345678"})
    changeset2 = User.changeset(%User{}, %{email: "kurt@example.com", app_id: app2.id, password: "12345678"})
    assert {:ok, _} = Repo.insert(changeset)
    assert {:ok, _} = Repo.insert(changeset2)
  end

  test "password gets hashed" do
    changeset = User.changeset(%User{}, @valid_attrs)
    {:ok, user} = Repo.insert(changeset)
    assert user.crypted_password != nil
  end

  test "existing password does not get destroyed" do
    {:ok, user} = Forge.saved_user(Repo, crypted_password: "stuff")
    changeset = User.changeset(user, %{app_id: "00000000-0000-0000-0000-000000000000", email: "kurt2@example.com"})
    {:ok, user} = Repo.update(changeset)
    assert user.crypted_password == "stuff"
    assert user.email == "kurt2@example.com"
  end

  test "password can be updated" do
    {:ok, user} = Forge.saved_user(Repo, crypted_password: "stuff")
    changeset = User.changeset(user, %{password: "12345678"})
    {:ok, user} = Repo.update(changeset)
    assert user.crypted_password != "stuff"
  end
end

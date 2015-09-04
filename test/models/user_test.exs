defmodule Bouncer.UserTest do
  use Bouncer.ModelCase

  alias Bouncer.User

  @valid_attrs %{email: "kurt@example.com", password: "12345678"}
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
    Repo.insert!(changeset)
    assert {:error, _} = Repo.insert(changeset)
  end

  test "password gets hashed" do
    changeset = User.changeset(%User{}, @valid_attrs)
    {:ok, user} = Repo.insert(changeset)
    assert user.crypted_password != nil
  end

  test "existing password does not get destroyed" do
    {:ok, user} = Repo.insert(%User{email: "kurt@example.com", crypted_password: "stuff"})
    changeset = User.changeset(user, %{email: "kurt2@example.com"})
    {:ok, user} = Repo.update(changeset)
    assert user.crypted_password == "stuff"
  end

  test "password can be updated" do
    {:ok, user} = Repo.insert(%User{email: "kurt@example.com", crypted_password: "stuff"})
    changeset = User.changeset(user, %{email: "kurt2@example.com", password: "12345678"})
    {:ok, user} = Repo.update(changeset)
    assert user.crypted_password != "stuff"
  end
end

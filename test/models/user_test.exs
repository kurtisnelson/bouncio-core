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
end

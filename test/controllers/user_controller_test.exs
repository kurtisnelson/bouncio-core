defmodule Bouncer.UserControllerTest do
  use Bouncer.ConnCase

  alias Bouncer.User
  @valid_attrs %{email: "kurt@example.com", password: "12345678"}
  @invalid_attrs %{email: "kurt", password: "1234"}
  @password_error %{"detail" => "should be at least 8 characters", "source" => %{"pointer" => "/data/attributes/password"}, "title" => "Invalid Attribute"}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, user_path(conn, :index)
    assert %{"data" => []} = json_response(conn, 200)
  end

  test "shows chosen resource", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = get conn, user_path(conn, :show, user)
    %{id: id, email: email} = user
    assert %{"data" => [%{"id" => ^id, "attributes" => %{"email" => ^email}}]} = json_response(conn, 200)
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, user_path(conn, :show, "ce567b52-e660-4657-9029-19465e72a03a")
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), %{data: %{ type: "users", attributes: @valid_attrs }}
    assert List.first(json_response(conn, 201)["data"])["id"]
    assert Repo.get_by(User, email: @valid_attrs.email)
  end

  test "creates and renders resource when ID is specified", %{conn: conn} do
    id = Ecto.UUID.generate
    conn = post conn, user_path(conn, :create), %{data: %{ id: id, type: "users", attributes: @valid_attrs }}
    assert List.first(json_response(conn, 201)["data"])["id"] == id
    assert Repo.get_by(User, email: @valid_attrs.email)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), %{data: %{ type: "users", attributes: @invalid_attrs }}
    assert %{"errors" => [@password_error, _]} = json_response(conn, 422)
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = put conn, user_path(conn, :update, user), %{data: %{ type: "users", attributes: @valid_attrs }}
    assert List.first(json_response(conn, 200)["data"])["id"]
    assert Repo.get_by(User, email: @valid_attrs.email)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = put conn, user_path(conn, :update, user), %{data: %{ type: "users", attributes: @invalid_attrs }}
    assert %{"errors" => [@password_error, _]} = json_response(conn, 422)
  end

  test "deletes chosen resource", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = delete conn, user_path(conn, :delete, user)
    assert response(conn, 204)
    refute Repo.get(User, user.id)
  end
end

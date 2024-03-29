defmodule Bouncio.UserControllerTest do
  use Bouncio.ConnCase

  alias Bouncio.User
  @valid_attrs %{email: "kurt@example.com", password: "12345678"}
  @valid_relationships %{app: %{data: %{id: Bouncio.App.internal_id } } }
  @invalid_attrs %{email: "kurt", password: "1234"}
  @password_error %{"detail" => "should be at least 8 characters", "source" => %{"pointer" => "/data/attributes/password"}, "title" => "Invalid Attribute"}

  setup do
    {:ok, user} = Forge.saved_user(Repo)
    conn = conn() |> put_req_header("accept", "application/json")
                  |> put_req_header("authorization", "Bearer " <> new_session(user).access_token)
    {:ok, conn: conn, current_user: user}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, user_path(conn, :index)
    assert %{"data" => [_]} = json_response(conn, 200)
  end

  test "shows chosen resource", %{conn: conn} do
    {:ok, user} = Forge.saved_user(Repo)
    conn = get conn, user_path(conn, :show, user)
    %{id: id, email: email} = user

    case json_response(conn, 200) do
          %{"data" => %{"attributes" => %{"email" => ^email}}} -> flunk
          %{"data" => %{"id" => ^id, "attributes" => %{"email-verified" => nil, "masked-email" => _}}} -> true
    end
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, user_path(conn, :show, "ce567b52-e660-4657-9029-19465e72a03a")
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), %{data: %{ type: "users", attributes: @valid_attrs, relationships: @valid_relationships }}
    assert %{"data" => %{"id" => _} } = json_response(conn, 201)
    assert Repo.get_by(User, email: @valid_attrs.email)
  end

  test "creates and renders resource when ID is specified", %{conn: conn} do
    id = Ecto.UUID.generate
    conn = post conn, user_path(conn, :create), %{data: %{ id: id, type: "users", attributes: @valid_attrs, relationships: @valid_relationships }}
    assert %{"data" => %{"id" => ^id}} = json_response(conn, 201)
    assert Repo.get_by(User, email: @valid_attrs.email)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), %{data: %{ type: "users", attributes: @invalid_attrs }}
    assert %{"errors" => [@password_error, _, _]} = json_response(conn, 422)
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    {:ok, user} = Forge.saved_user(Repo)
    conn = put conn, user_path(conn, :update, user), %{data: %{ type: "users", attributes: @valid_attrs, relationships: @valid_relationships }}
    assert %{"data" => %{"id" => _}} = json_response(conn, 200)
    assert Repo.get_by(User, email: @valid_attrs.email)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    {:ok, user} = Forge.saved_user(Repo)
    conn = put conn, user_path(conn, :update, user), %{data: %{ type: "users", attributes: @invalid_attrs }}
    assert %{"errors" => [@password_error, _, _]} = json_response(conn, 422)
  end

  test "deletes chosen resource", %{conn: conn} do
    {:ok, user} = Forge.saved_user(Repo)
    conn = delete conn, user_path(conn, :delete, user)
    assert response(conn, 204)
    refute Repo.get(User, user.id)
  end
end

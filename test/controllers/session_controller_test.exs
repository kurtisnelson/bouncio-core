defmodule Bouncio.SessionControllerTest do
  use Bouncio.ConnCase

  alias Bouncio.User

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "user can log in", %{conn: conn} do
    email = "kurt@example.com"
    password = "12345678"
    Repo.insert! User.changeset(%User{}, %{email: email, password: password, app_id: Bouncio.App.internal_id})
    conn = post conn, session_path(conn, :create), [grant_type: 'password', username: email, password: password]
    assert %{"access_token" => _, "token_type" => "Bearer", "refresh_token" => _, "expires_in" => 7200, "id_token" => _} = json_response(conn, :created)
  end

  test "invalid user is unauthorized", %{conn: conn} do
    email = "kurt@example.com"
    password = "wrongpassword"
    conn = post conn, session_path(conn, :create), %{grant_type: 'password', username: email, password: password}
    assert %{"error" => _ } = json_response(conn, :bad_request)
  end

  test "issued token is valid", %{conn: conn} do
    email = "kurt@example.com"
    password = "12345678"
    user = Repo.insert! User.changeset(%User{}, %{email: email, password: password, app_id: Bouncio.App.internal_id})
    conn = post conn, session_path(conn, :create), [grant_type: 'password', username: email, password: password]
    %{"access_token" => token, "token_type" => "Bearer"} = json_response(conn, :created)
    conn = conn() |> put_req_header("authorization", "Bearer " <> token) |> get session_path(conn, :show)
    user_id = user.id
    assert %{"expires_in" => expires_in, "user_id" => ^user_id} = json_response(conn, 200)
    assert expires_in > 0
  end

  test "token can be destroyed", %{conn: conn} do
    email = "kurt@example.com"
    password = "12345678"
    Repo.insert! User.changeset(%User{}, %{email: email, password: password, app_id: Bouncio.App.internal_id})
    conn = post conn, session_path(conn, :create), [grant_type: 'password', username: email, password: password]
    %{"access_token" => token, "token_type" => "Bearer"} = json_response(conn, :created)
    conn = conn() |> put_req_header("authorization", "Bearer " <> token) |> delete session_path(conn, :delete)
    assert json_response(conn, :no_content) 
    conn = conn() |> put_req_header("authorization", "Bearer " <> token) |> get session_path(conn, :show)
    assert json_response(conn, :bad_request)
  end
end

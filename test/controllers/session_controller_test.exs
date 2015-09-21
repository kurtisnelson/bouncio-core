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
    assert %{"access_token" => _, "token_type" => "Bearer", "refresh_token" => _, "expires_in" => 3600, "id_token" => _} = json_response(conn, 201)
  end

  test "invalid user is unauthorized", %{conn: conn} do
    email = "kurt@example.com"
    password = "wrongpassword"
    conn = post conn, session_path(conn, :create), %{grant_type: 'password', username: email, password: password}
    assert %{"error" => _ } = json_response(conn, :bad_request)
  end
end

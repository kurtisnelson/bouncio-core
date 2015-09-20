defmodule Bouncer.SessionControllerTest do
  use Bouncer.ConnCase

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "user can log in", %{conn: conn} do
    email = "kurt@example.com"
    password = "12345678"
    conn = post conn, session_path(conn, :create), %{grant_type: 'password', username: email, password: password}
    assert %{"token" => _} = json_response(conn, 201)
  end

  test "invalid user is unauthorized", %{conn: conn} do
    email = "kurt@example.com"
    password = "wrongpassword"
    conn = post conn, session_path(conn, :create), %{grant_type: 'password', username: email, password: password}
    assert json_response(conn, 403)
  end
end

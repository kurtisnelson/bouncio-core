defmodule Bouncio.SessionControllerTest do
  use Bouncio.ConnCase

  alias Bouncio.User

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "user can log in", %{conn: conn} do
    assert %{"access_token" => _, "token_type" => "Bearer", "refresh_token" => _, "expires_in" => 7200, "id_token" => _} = create_and_login_user()
  end

  test "invalid user is unauthorized", %{conn: conn} do
    conn = post conn, session_path(conn, :create), %{grant_type: "password", username: Faker.Internet.email(), password: Faker.Lorem.characters(8..255)}
    assert %{"error" => _ } = json_response(conn, :bad_request)
  end

  test "issued token is valid", %{conn: conn} do
    %{"access_token" => token, "token_type" => "Bearer", "user_id" => user_id} = create_and_login_user()
    conn = conn() |> put_req_header("authorization", "Bearer " <> token) |> get session_path(conn, :show)
    assert %{"expires_in" => expires_in, "user_id" => ^user_id} = json_response(conn, 200)
    assert expires_in > 0
  end

  test "token can be destroyed", %{conn: conn} do
    %{"access_token" => token, "token_type" => "Bearer"} = create_and_login_user()
    conn = conn() |> put_req_header("authorization", "Bearer " <> token) |> delete session_path(conn, :delete)
    assert json_response(conn, :no_content) 
    conn = conn() |> put_req_header("authorization", "Bearer " <> token) |> get session_path(conn, :show)
    assert json_response(conn, :bad_request)
  end

  test "refresh token can be used", %{conn: conn} do
    %{"refresh_token" => refresh_token, "access_token" => token} = create_and_login_user()
    conn = conn() |> post session_path(conn, :create), [grant_type: "refresh_token", refresh_token: refresh_token]
    assert %{"access_token" => new_token, "refresh_token" => new_refresh_token, "expires_in" => 7200} = json_response(conn, :created)
    assert new_token != token
    assert new_refresh_token != refresh_token
  end

  defp create_and_login_user do
    create_and_login_user(Faker.Internet.email(), to_string(Faker.Lorem.characters(8..255)))
  end

  defp create_and_login_user(email, password) do
    user = Repo.insert! User.changeset(%User{}, %{email: email, password: password, app_id: Bouncio.App.internal_id})
    conn = conn |> post session_path(conn, :create), [grant_type: "password", username: email, password: password]
    Map.merge(json_response(conn, :created), %{"user_id" => user.id})
  end
end

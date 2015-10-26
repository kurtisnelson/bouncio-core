defmodule Bouncio.ConnHelper do
  import Phoenix.ConnTest
  @endpoint Bouncio.Endpoint

  import Bouncio.Router.Helpers
  def create_and_login_user do
    create_and_login_user(Faker.Internet.email(), to_string(Faker.Lorem.characters(8..255)))
  end

  def create_and_login_user(email, password) do
    user = Bouncio.Repo.insert! Bouncio.User.changeset(%Bouncio.User{}, %{email: email, password: password, app_id: Bouncio.App.internal_id})
    conn = conn() |> post session_path(conn, :create), [grant_type: "password", username: email, password: password]
    Map.merge(json_response(conn, :created), %{"user_id" => user.id})
  end

  def create_user_token do
    #slow and terrible way to get a valid token
    %{"access_token" => token}= create_and_login_user 
    token
  end
end

defmodule Bouncio.ConnHelper do
  import Phoenix.ConnTest
  @endpoint Bouncio.Endpoint

  alias Bouncio.Session

  import Bouncio.Router.Helpers
  def create_and_login_user do
    create_and_login_user(Faker.Internet.email(), to_string(Faker.Lorem.characters(8..255)))
  end

  def create_and_login_user(email, password) do
    user = Bouncio.Repo.insert! Bouncio.User.changeset(%Bouncio.User{}, %{email: email, password: password, app_id: Bouncio.App.internal_id})
    conn = conn() |> post session_path(conn, :create), [grant_type: "password", username: email, password: password]
    Map.merge(json_response(conn, :created), %{"user_id" => user.id})
  end

  def new_session(user) when is_map(user) do
    {:ok, session} = Session.new(user)
    session
  end
end

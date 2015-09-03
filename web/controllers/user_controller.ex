defmodule Bouncer.UserController do
  use Bouncer.Web, :controller

  alias Bouncer.User

  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.json", data: users)
  end

  def create(conn, %{"data" => user_data}) do
    id = %{"id" => user_data["id"]}
    changeset = User.changeset(%User{}, Map.merge(id, user_data["attributes"]))

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> render("show.json", data: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Bouncer.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    render conn, "show.json", data: user
  end

  def update(conn, %{"id" => id, "data" => %{"attributes" => user_attrs}}) do
    user = Repo.get!(User, id)
    changeset = User.changeset(user, user_attrs)

    case Repo.update(changeset) do
      {:ok, user} ->
        render(conn, "show.json", data: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Bouncer.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get!(User, id)

    Repo.delete!(user)

    send_resp(conn, :no_content, "")
  end
end

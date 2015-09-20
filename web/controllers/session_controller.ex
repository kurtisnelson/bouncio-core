defmodule Bouncio.SessionController do
  use Bouncio.Web, :controller

  alias Bouncio.Session

  def create(conn, session_params) do
    case Session.login(session_params, Repo) do
      {:ok, session} ->
        conn
        |> fetch_session
        |> put_session(:current_user, session.user_id)
        |> put_status(:created)
        |> render("show.json", session: session)
      :error ->
        conn
        |> put_status(:unauthorized)
    end
  end

  def show(conn) do

  end

  def delete(conn) do

  end
end

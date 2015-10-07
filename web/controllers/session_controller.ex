defmodule Bouncio.SessionController do
  use Bouncio.Web, :controller

  alias Bouncio.Session
  plug :secure_cache_headers

  def create(conn, session_params) do
    case Session.from_params(session_params) do
      {:ok, session} ->
        conn
        |> fetch_session
        |> put_session(:current_user, session.user_id)
        |> put_status(:created)
        |> render "new.json", session: session
      _ ->
        conn
        |> fetch_session
        |> put_session(:current_user, nil)
        |> put_status(:bad_request)
        |> json %{error: "invalid_request"}
    end
  end

  def show(conn, _) do
    token = conn |> get_req_header("authorization") |> parse_token_header
    case Session.from_bearer(token) do
      {:ok, session} ->
        conn
        |> put_status(:ok)
        |> render "show.json", session: session
      _ ->
        conn
        |> put_status(:bad_request)
        |> json %{error: "invalid_request"}
    end
  end

  def delete(conn, _) do
    conn |> get_req_header("authorization") |> parse_token_header |> Session.from_bearer |> destroy_session(conn)
  end

  def revoke(conn, %{"token_type_hint" => type, "token" => token}) do
    case type do
      "refresh_token" ->
        token |> Session.from_refresh |> destroy_session(conn)
      "access_token" ->
        token |> Session.from_bearer |> destroy_session(conn)
    end
  end

  defp secure_cache_headers(conn, _) do
    Plug.Conn.put_resp_header(conn, "cache-control", "no-store, private")
    Plug.Conn.put_resp_header(conn, "pragma", "no-cache")
  end

  defp destroy_session(session_result, conn) do
    case session_result do
      {:ok, session} ->
        Repo.delete!(session)
    end
    conn
    |> put_status(:no_content)
    |> json ""
  end

  defp parse_token_header(["Bearer " <> token]), do: token
  defp parse_token_header(_), do: ""
end

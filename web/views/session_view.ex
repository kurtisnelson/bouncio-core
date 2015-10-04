defmodule Bouncio.SessionView do
  use Bouncio.Web, :view
  alias Bouncio.Session

  def render("new.json", %{session: session}) do
    %{access_token: session.access_token, token_type: "Bearer", refresh_token: session.refresh_token, expires_in: Session.expires_in(session), id_token: Session.id_token(session)}
  end

  def render("show.json", %{session: session}) do
    %{user_id: session.user_id, expires_in: Session.expires_in(session)}
  end
end

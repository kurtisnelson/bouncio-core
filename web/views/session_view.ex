defmodule Bouncio.SessionView do
  use Bouncio.Web, :view

  def render("new.json", %{session: session}) do
    %{access_token: session.access_token, token_type: "Bearer", refresh_token: session.refresh_token, expires_in: session.expires_in, id_token: session.id_token}
  end

  def render("show.json", %{session: session}) do
    %{user_id: session.user_id, expires_in: session.expires_in}
  end
end

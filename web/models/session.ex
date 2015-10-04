defmodule Bouncio.Session do
  use Bouncio.Web, :model
  use Timex
  import MultiDef
  alias Bouncio.User
  alias Bouncio.Repo
  alias Bouncio.Session

  schema "sessions" do
    belongs_to :user, User
    field :access_token, :string
    field :refresh_token, :string
    field :expires_at, Timex.Ecto.DateTime
    timestamps
  end

  @required_fields ~w(user_id)
  @optional_fields ~w(expires_at)

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> foreign_key_constraint(:user_id)
    |> generate_token(:access_token)
    |> generate_token(:refresh_token)
    |> update_expires_at
  end

  def expires_in(session) do
    Date.diff(Date.now, session.expires_at, :secs)
  end

  def id_token(session) do
    "" # eventually return a JWT
  end

  mdef from_bearer do
    nil -> :error
    token -> validate_session(Repo.get_by(Session, access_token: token))
  end

  mdef from_refresh do
    nil -> :error
    token -> validate_session(Repo.get_by(Session, refresh_token: token))
  end

  def from_params(params) do
    user = Repo.get_by(User, email: String.downcase(params["username"]))
    from_password(user, params["password"])
  end

  def from_password(user, password) do
    case authenticate(user, password) do
      true -> build_session(user)
      _    -> :error
    end
  end

  mdef authenticate do
    nil, _ -> false
    user, password -> Comeonin.Bcrypt.checkpw(password, user.crypted_password)
  end

  def build_session(user) do
    Bouncio.Repo.insert(Session.changeset(%Session{}, %{user_id: user.id}))
  end

  defp validate_session(session) when is_nil(session) do
    :error
  end

  defp validate_session(session) do
    case expires_in(session) > 0 do
      true ->
        {:ok, session}
      _ ->
        :error
    end
  end

  defp update_expires_at(changeset) do
    expires_at = Date.now |> Date.add(Time.to_timestamp(2, :hours))
    changeset |> put_change(:expires_at, expires_at)
  end

  defp generate_token(changeset, field) do
    changeset |> put_change(field, random_token)
  end

  defp random_token do
    :crypto.strong_rand_bytes(32) |> :base64.encode_to_string |> to_string
  end
end

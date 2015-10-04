defmodule Bouncio.Router do
  use Bouncio.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json-api", "json"]
  end

  scope "/", Bouncio do
    pipe_through :api
    resources "/users", UserController, except: [:new]
    resources "/apps", AppController, except: [:new]
    post "/session", SessionController, :create
    delete "/session", SessionController, :delete
    post "/session/revoke", SessionController, :revoke
    get "/session", SessionController, :show
  end
end

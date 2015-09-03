defmodule Bouncer.Router do
  use Bouncer.Web, :router

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

  scope "/", Bouncer do
    pipe_through :api
    resources "/users", UserController, except: [:new]
    post "/session", SessionController, :new
    delete "/session", SessionController, :delete
    get "/session", SessionController, :show
  end
end

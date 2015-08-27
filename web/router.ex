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
    plug PlugCors, [origins: ["*"]]
  end

  scope "/", Bouncer do
    pipe_through :api
    resources "/users", UserController
  end
end

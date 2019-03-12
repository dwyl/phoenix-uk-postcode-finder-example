defmodule StoreFinderWeb.Router do
  use StoreFinderWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", StoreFinderWeb do
    pipe_through :browser

    get "/", PageController, :index
    post "/nearby-stores", PageController, :nearby_stores
  end
end

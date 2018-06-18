defmodule MxnUsdExchangeWeb.Router do
  use MxnUsdExchangeWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1", MxnUsdExchangeWeb do
    pipe_through :api

    get "/mxn_to_usd", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", MxnUsdExchangeWeb do
  #   pipe_through :api
  # end
end

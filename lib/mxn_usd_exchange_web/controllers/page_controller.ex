defmodule MxnUsdExchangeWeb.PageController do
  use MxnUsdExchangeWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end

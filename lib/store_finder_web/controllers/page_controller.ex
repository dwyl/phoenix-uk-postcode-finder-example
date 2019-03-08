defmodule StoreFinderWeb.PageController do
  use StoreFinderWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end

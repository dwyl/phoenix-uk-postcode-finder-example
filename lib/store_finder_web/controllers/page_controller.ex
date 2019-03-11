defmodule StoreFinderWeb.PageController do
  use StoreFinderWeb, :controller
  alias StoreFinder.Haversine

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def nearby_stores(conn, %{"postcode" => _postcode, "within" => within}) do
    # converts within from a string to an integer
    {within, _} = Integer.parse(within)

    # use postcode value to get lat_long. Replace hard coded value
    lat_long = {51.554031, 0.051446}

    nearby_stores = Haversine.find_nearest_stores(lat_long, within)

    render(conn, "store.html", stores: nearby_stores)
  end
end

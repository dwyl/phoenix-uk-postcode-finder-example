defmodule StoreFinderWeb.PageController do
  use StoreFinderWeb, :controller
  alias StoreFinder.Haversine

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def nearby_stores(conn, %{"postcode" => postcode, "within" => within}) do
    if valid_postcode_format?(postcode) do
      # use postcode value to get lat_long. Replace hard coded value
      lat_long = {51.554031, 0.051446}

      # converts within from a string to an integer
      {within, _} = Integer.parse(within)

      nearby_stores = Haversine.find_nearest_stores(lat_long, within)

      render(conn, "store.html", stores: nearby_stores)
    else
      render(conn, "store.html", stores: [])
    end
  end

  # Mention that I got this from dwyl fields
  defp valid_postcode_format?(postcode) do
    regex =
      Regex.compile(
        "^([A-Za-z][A-Za-z]?[0-9][A-Za-z0-9]? ?[0-9][A-Za-z]{2}|[Gg][Ii][Rr] ?0[Aa]{2})$"
      )

    Regex.match?(regex, postcode)
  end
end

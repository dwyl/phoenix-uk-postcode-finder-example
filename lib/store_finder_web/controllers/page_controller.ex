defmodule StoreFinderWeb.PageController do
  use StoreFinderWeb, :controller
  alias StoreFinder.Haversine

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def nearby_stores(conn, %{"postcode" => postcode, "within" => within}) do
    if valid_postcode_format?(postcode) do
      
      postcode_char = String.to_charlist(postcode)
      {:ok, {{'HTTP/1.1', 200, 'OK'}, _headers, body}} =
        :httpc.request(:get, {'https://api.postcodes.io/postcodes/' ++ postcode_char, []}, [], [])

      {:ok, parsed_body} = Jason.decode(body)
      lat = parsed_body["result"]["latitude"]
      long = parsed_body["result"]["longitude"]

      # converts within from a string to an integer
      {within, _} = Integer.parse(within)

      nearby_stores = Haversine.find_nearest_stores({lat, long}, within)

      render(conn, "store.html", stores: nearby_stores)
    else
      render(conn, "store.html", stores: [])
    end
  end

  defp check_postcode_with_postcodesio(postcode) do
    postcode = String.replace(postcode, " ", "")
    HTTPoison.get(~s(api.postcodes.io/postcodes/#{postcode}))
  end
  # Mention that I got this from dwyl fields
  defp valid_postcode_format?(postcode) do
    regex =
      Regex.compile!(
        "^([A-Za-z][A-Za-z]?[0-9][A-Za-z0-9]? ?[0-9][A-Za-z]{2}|[Gg][Ii][Rr] ?0[Aa]{2})$"
      )

    Regex.match?(regex, postcode)
  end
end

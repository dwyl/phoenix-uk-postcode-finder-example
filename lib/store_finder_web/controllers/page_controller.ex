defmodule StoreFinderWeb.PageController do
  use StoreFinderWeb, :controller
  alias StoreFinder.Haversine

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def nearby_stores(conn, %{"postcode" => postcode, "within" => within}) do
    case check_postcode(postcode) do
      false ->
        conn
        |> put_flash(:error, "invalid postcode")
        |> redirect(to: "/")

      decoded_response ->
        lat = decoded_response["result"]["latitude"]
        long = decoded_response["result"]["longitude"]
        {within, _} = Integer.parse(within)
        nearby_stores = Haversine.find_nearest_stores({lat, long}, within)

        render(conn, "nearby_stores.html", stores: nearby_stores)
    end
  end

  # HELPERS
  defp check_postcode(postcode) do
    with valid_postcode_format?(postcode),
    {:ok, res} <- check_postcode_with_postcodesio(postcode),
    %{"status" => 200} <- Jason.decode!(res.body) do
      Jason.decode!(res.body)
    else
      (_ -> false)
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

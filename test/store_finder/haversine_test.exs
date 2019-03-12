defmodule StoreFinder.HaversineTest do
  use StoreFinderWeb.ConnCase
  alias StoreFinder.Haversine

  test "ets table exists when application starts" do
    stores = :ets.match_object(:store_cache, :_)
    assert is_list(stores)
    refute Enum.empty?(stores)
  end

  test "find_nearest_stores returns nearby stores" do
    ll = {51.563729, -0.107694}

    # becase I am using dummy data I know how many venues are in a 1km and 10km
    # radius of the given lat-long
    assert Haversine.find_nearest_stores(ll, 1) == []
    assert Haversine.find_nearest_stores(ll, 10) |> length() == 5
  end
end
defmodule StoreFinder.CreateStoresTest do
  use StoreFinderWeb.ConnCase
  alias StoreFinder.CreateStores

  describe "tests get_random_postcodes" do
    test "returns error messages when given incorrect value" do
      too_few = CreateStores.get_random_postcodes(-1)
      too_many = CreateStores.get_random_postcodes(200)
      string = CreateStores.get_random_postcodes("hello")

      assert too_few == "arg needs to be at least 1"
      assert too_many == "arg needs to be less than 200"
      assert string == "Need to pass integer"
    end

    test "returns a list of tuples when given int over 0" do
      stores = CreateStores.get_random_postcodes(1)

      assert is_list(stores)
      assert is_tuple(Enum.at(stores, 0))
    end
  end
end

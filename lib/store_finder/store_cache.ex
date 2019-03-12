defmodule StoreFinder.StoreCache do
  use GenServer

  def start_link(init_arg) do
    GenServer.start_link(__MODULE__, init_arg, name: StoreCache)
  end

  def init(initial_state) do
    :ets.new(:store_cache, [:set, :public, :named_table])
    :ets.insert(:store_cache, StoreFinder.CreateStores.get_store_list())

    {:ok, initial_state}
  end
end
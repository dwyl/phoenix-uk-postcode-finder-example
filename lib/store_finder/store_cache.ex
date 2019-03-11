defmodule StoreFinder.StoreCache do
  use GenServer
  alias StoreFinder.CreateStores

  def start_link do
    GenServer.start_link(__MODULE__, %{}, name: StoreCache)
  end

  def init(initial_state) do
    :ets.new(:store_cache, [:set, :public, :named_table])
    |> cache_store_info(CreateStores.get_store_list())

    {:ok, initial_state}
  end

  defp cache_store_info(cache, list) do
    Enum.each(list, &(:ets.insert_new(cache, &1)))
  end
end
defmodule StoreFinder.Haversine do
  def calc_distance({lat1, long1}, {lat2, long2}) do
    v = :math.pi / 180
    r = 6372.8

    dlat  = :math.sin((lat2 - lat1) * v / 2)
    dlong = :math.sin((long2 - long1) * v / 2)
    a = dlat * dlat + dlong * dlong * :math.cos(lat1 * v) * :math.cos(lat2 * v)
    r * 2 * :math.asin(:math.sqrt(a))
  end

  def find_nearest_stores(latlong, distance) do
    :ets.foldl(fn(ets_tuple, acc) ->
      {postcode, lat, long} = ets_tuple

      if calc_distance({lat, long}, latlong) < distance,
        do: [{postcode, lat, long} | acc],
        else: acc
    end, [], :store_cache)
  end
end

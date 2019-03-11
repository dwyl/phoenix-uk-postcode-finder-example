defmodule StoreFinder.UKPostcodes do
  @csv_url "https://raw.githubusercontent.com/dwyl/uk-postcodes-latitude-longitude-complete-csv/master/ukpostcodes.csv.zip"
  @zip_file_name "postcodes.zip"
  @zip_file_name_charlist String.to_charlist(@zip_file_name)

  # Gets zip file from github and saves the response to body then writes the
  # zip file to allow it to be unzipped so the csv can be extracted
  def create_csv_file() do
    {:ok, res} = HTTPoison.get(@csv_url)

    case File.write(@zip_file_name, res.body) do
      :ok ->
        IO.inspect("Created zip file")
        unzip_file_name()

      error ->
        error
    end
  end

  # Helper to unzip file and only take ukpostcodes.csv
  # If file is succesfully unziped then it deletes the zip file
  defp unzip_file_name do
    case :zip.extract(@zip_file_name_charlist, [{:file_list, ['ukpostcodes.csv']}]) do
      {:ok, _fileList} ->
        IO.inspect("Postcodes successfully unzipped")
        File.rm(@zip_file_name)
      error ->
        error
    end
  end
end

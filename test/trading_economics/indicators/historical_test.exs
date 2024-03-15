defmodule TradingEconomics.Indicators.HistoricalTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Finch

  alias TradingEconomics.Indicators.Historical

  @api_key System.get_env("TE_API_KEY")

  test "by country and indicator" do
    use_cassette "by country and indicator" do
      assert {:ok, data} = Historical.get(@api_key, ["mexico", "sweden"], ["gdp", "population"])
      assert 254 = length(data)

      assert %Historical{country: "Mexico", category: "GDP", frequency: "Yearly", value: 13.04} =
               Enum.at(data, 0)

      assert %Historical{country: "Mexico", category: "Population", value: 38.68} =
               Enum.at(data, 1)

      assert %Historical{country: "Sweden", category: "GDP", value: 15.82} = Enum.at(data, 2)
    end
  end

  test "by country and indicator and start date" do
    use_cassette "by country and indicator and start date" do
      assert {:ok, data} = Historical.get(@api_key, "mexico", "gdp", start_date: "2018-01-01")
      assert 6 = length(data)

      assert %Historical{country: "Mexico", category: "GDP", date_time: "2018-12-31T00:00:00"} =
               Enum.at(data, 0)
    end
  end

  test "by country and indicator and end date" do
    assert {:error, "either :start_date or both" <> _} =
             Historical.get(@api_key, "mexico", "gdp", end_date: "2018-01-01")
  end

  test "by country and indicator and start date and end_date" do
    use_cassette "by country and indicator and start date and end_date" do
      assert {:ok, data} =
               Historical.get(@api_key, "mexico", "gdp",
                 start_date: "2018-01-01",
                 end_date: "2021-01-01"
               )

      assert 4 = length(data)

      assert %Historical{country: "Mexico", category: "GDP", date_time: "2020-12-31T00:00:00"} =
               Enum.at(data, -2)
    end
  end

  test "by country and indicator and start date and end_date in raw format" do
    use_cassette "by country and indicator and start date and end_date in raw format" do
      assert {:ok, data} =
               Historical.get(@api_key, "mexico", "gdp",
                 start_date: "2018-01-01",
                 end_date: "2019-01-01",
                 raw: true
               )

      assert 2 = length(data)

      assert %{
               "Country" => "Mexico",
               "Category" => "GDP",
               "DateTime" => "2018-12-31T00:00:00"
             } = Enum.at(data, 0)
    end
  end

  # test "by country and indicator and start date and end_date in csv format" do
  #   use_cassette "by country and indicator and start date and end_date in csv format" do
  #     assert {:ok, data} =
  #              Historical.get(@api_key, "mexico", "gdp",
  #                start_date: "2018-01-01",
  #                end_date: "2019-01-01",
  #                raw: true,
  #                f: "csv"
  #              )

  #     assert %{
  #              "Country" => "Mexico",
  #              "Category" => "GDP",
  #              "DateTime" => "2018-12-31T00:00:00"
  #            } = Enum.at(data, 0)
  #   end
  # end
end

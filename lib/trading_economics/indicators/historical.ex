defmodule TradingEconomics.Indicators.Historical do
  @moduledoc "https://docs.tradingeconomics.com/indicators/historical/"

  alias TradingEconomics.HttpClient

  @type t :: %__MODULE__{
          country: binary,
          category: binary,
          date_time: binary,
          value: number,
          frequency: binary,
          historical_data_symbol: binary,
          last_update: binary
        }
  defstruct ~w(country category date_time value frequency historical_data_symbol last_update)a
  @type api_key :: TradingEconomics.api_key()
  @type country :: binary | list(binary)
  @type indicator :: binary | list(binary)
  @type result :: {:ok, list(t)} | {:error, term}
  @type format :: :json | :csv | :xml
  @type opts :: [start_date: binary, end_date: binary, raw: boolean]

  @path "/historical/country/:country/indicator/:indicator"
  @path_with_start_date @path <> "/:start_date"
  @path_with_end_date @path_with_start_date <> "/:end_date"

  @spec get(api_key, country, indicator, opts) :: result
  def get(api_key, country, indicator, opts \\ [])

  def get(api_key, country, indicator, [start_date: start_date, end_date: end_date] = opts) do
    path_params = [
      country: to_param(country),
      indicator: to_param(indicator),
      start_date: start_date,
      end_date: end_date
    ]

    exec(api_key, @path_with_end_date, path_params, opts)
  end

  def get(_api_key, _country, _indicator, [end_date: _end_date] = _opts) do
    {:error, "either :start_date or both :start_date and :end_date args are required"}
  end

  def get(api_key, country, indicator, [start_date: start_date] = opts) do
    path_params = [
      country: to_param(country),
      indicator: to_param(indicator),
      start_date: start_date
    ]

    exec(api_key, @path_with_start_date, path_params, opts)
  end

  def get(api_key, country, indicator, opts) do
    path_params = [country: to_param(country), indicator: to_param(indicator)]
    exec(api_key, @path, path_params, opts)
  end

  defp exec(api_key, path, path_params, opts) do
    {raw, opts} = Keyword.pop(opts, :raw)

    path
    |> HttpClient.get(api_key, path: path_params, query: opts)
    |> build_response(raw: raw)
  end

  defp build_response({:error, error}, raw: _), do: {:error, error}
  defp build_response({:ok, response}, raw: true), do: {:ok, response.body}
  defp build_response({:ok, response}, raw: _), do: {:ok, Enum.map(response.body, &build(&1))}

  defp build(map) do
    {:ok, historical} =
      Mapail.map_to_struct(map, __MODULE__, transformations: [:snake_case], rest: false)

    historical
  end

  defp to_param(data) when is_list(data), do: Enum.join(data, ",")
  defp to_param(data), do: data
end

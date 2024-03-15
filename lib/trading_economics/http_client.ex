defmodule TradingEconomics.HttpClient do
  @moduledoc "HTTP Client"

  @type api_key :: TradingEconomics.api_key()

  @spec api_url :: binary
  def api_url() do
    Application.get_env(:trading_economics, :api_url, "https://api.tradingeconomics.com")
  end

  @spec get(binary, api_key, map) :: {:ok, term} | {:error, term}
  def get(api_path, api_key, params) do
    req = Req.new(base_url: api_url())

    Req.get(req,
      url: api_path,
      path_params: params[:path],
      params: Keyword.merge([c: api_key], params[:query])
    )
  end
end

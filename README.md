# TradingEconomics

TradingEconomics API Client for Elixir.

## Installation

Add `trading_economics` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:trading_economics, "~> 0.1.0"}
  ]
end
```
## Usage

### API KEY
Go to https://developer.tradingeconomics.com/ and create an API_KEY or use "guest:guest" but it will always return the same 3 records.

```elixir
alias TradingEconomics.Indicators.Historical
api_key = "guest:guest"
```
#### Single indicator for a country.

```elixir
iex(1)> {:ok, data} = Historical.get(api_key, "mexico", "gdp")
{:ok,
 [
   %TradingEconomics.Indicators.Historical{
     country: "Mexico",
     category: "GDP",
     date_time: "2020-12-31T00:00:00",
     value: 1120.74,
     frequency: "Yearly",
     historical_data_symbol: "WGDPMEXI",
     last_update: "2024-01-02T15:00:00"
   },
   %TradingEconomics.Indicators.Historical{
     country: "Mexico",
     category: "GDP",
     date_time: "2021-12-31T00:00:00",
     value: 1312.56,
     frequency: "Yearly",
     historical_data_symbol: "WGDPMEXI",
     last_update: "2024-01-02T15:00:00"
   },
   %TradingEconomics.Indicators.Historical{
     country: "Mexico",
     category: "GDP",
     date_time: "2022-12-31T00:00:00",
     value: 1465.85,
     frequency: "Yearly",
     historical_data_symbol: "WGDPMEXI",
     last_update: "2024-01-02T15:00:00"
   }
 ]}
```

#### Multiple indicators and countries.

```elixir
{:ok, data} = Historical.get(api_key, ["mexico", "sweden"], ["gdp", "population"])
```

#### From start date

```elixir
{:ok, data} = Historical.get(api_key, ["mexico", "sweden"], ["gdp", "population"], start_date: "2018-01-01")
```

#### Between start date and end date

```elixir
{:ok, data} = Historical.get(api_key, ["mexico", "sweden"], ["gdp", "population"], start_date: "2018-01-01", end_date: "2020-01-01")
```

## API Status

https://docs.tradingeconomics.com/get_started/

#### Indicators

- [ ] `Snapshot`
- [x] `Historical`
- [ ] `Peers`
- [ ] `Credit Ratings`

#### Economic Calendars

##### TBD

## Authors

* Iulian Costan

## License

`trading_economics` is released under the [MIT license](./LICENSE.md)

## Documentation

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/trading_economics>.

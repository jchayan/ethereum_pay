defmodule EthereumPay.Exchange do
  @moduledoc """
  Converts ETH to USD
  """
  use Memoize

  @api_url 'https://min-api.cryptocompare.com/data/price?fsym=USD&tsyms=ETH'
  @expire_time 1 * 60 * 1000
  @wei 1000000000000000000

  defmodule PriceFetchError do
    defexception message: 'Failed to fetch price data'
  end

  @doc """
  Gets the current USD price in ETH 
  """
  defmemo fetch, expires_in: @expire_time do
    case HTTPoison.get! @api_url do
      %HTTPoison.Response{status_code: 200, body: body} ->
        body |> Poison.decode |> elem(1)
      _ ->
        raise PriceFetchError
    end
  end

  def usd_to_eth(amount) do
   amount * (fetch() |> Map.get("ETH"))
  end

  def eth_to_wei(eth), do: floor eth * @wei

end

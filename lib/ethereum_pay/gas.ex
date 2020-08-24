defmodule EthereumPay.Gas do
  @moduledoc """
  Handles gas related operations
  """
  use Memoize

  @api_url 'https://ethgasstation.info/json/ethgasAPI.json'
  @expire_time 5 * 60 * 1000

  defmodule GasFetchError do
    defexception message: 'Failed to fetch gas data'
  end

  @doc """
  Gets the current gas prices from external API (memoized)
  ETH Gas Station API returns gas in Gwei * 10 for some reason
  """
  defmemo fetch, expires_in: @expire_time do
    case HTTPoison.get! @api_url do
      %HTTPoison.Response{status_code: 200, body: body} ->
        body |> Poison.decode |> elem(1)
      _ ->
        raise GasFetchError
    end
  end

  def current_price do 
    %{ "average" => gas_price } = fetch()
    floor((gas_price / 10) * 1000000000)
  end
end

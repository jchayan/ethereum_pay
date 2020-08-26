defmodule EthereumPay.Transaction do

  alias ETH.Transaction, as: EthTx

  defdelegate send_raw_transaction(transaction), to: EthTx, as: :send
  defdelegate sign_transaction(transaction, pvkey), to: EthTx, as: :sign_transaction

  use EthereumPay.Tasks

  @wei 1000000000000000000

  def eth_to_wei(eth) do
    floor eth * @wei
  end

  defp binary_to_hex(binary) do
    "0x" <> (binary |> Base.encode16)
  end

  defp build_transaction(params) do
    %{
      to: params[:wallet],
      gas_limit: 21000,
      data: nil,
      value: params[:value],
      nonce: params[:nonce],
      chain_id: 4,
      gas_price: params[:gas_price]
    }
  end

  defp send_transaction(private_key, amount, wallet, [tx_count, gas_price]) do
    [wallet: wallet, value: amount, nonce: tx_count, gas_price: gas_price]
    |> build_transaction
    |> sign_transaction(private_key)
    |> binary_to_hex
    |> send_raw_transaction
  end

  def send(sender, wallet, amount) do
    tasks = sender.address |> transaction_data

    if tasks.error |> Enum.count > 0 do
      {:error, tasks.error |> Enum.join("\n")}
    else
      send_transaction(sender.private_key, amount |> eth_to_wei, wallet, tasks.success)
    end
  end

end

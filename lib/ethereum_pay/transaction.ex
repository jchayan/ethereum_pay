defmodule EthereumPay.Transaction do

  require Logger

  alias ETH.Transaction, as: EthTx
  alias EthereumPay.NonceManager, as: NonceManager

  defdelegate send_raw(transaction), to: Ethereumex.HttpClient, as: :eth_send_raw_transaction
  defdelegate sign(transaction, pvkey), to: EthTx, as: :sign_transaction

  @wei 1000000000000000000

  def eth_to_wei(eth), do: floor eth * @wei

  defp hex_encode (binary) do
    "0x" <> (binary |> Base.encode16)
  end

  defp build(receiver, amount, nonce) do
    %{
      to: receiver,
      gas_limit: 21000,
      data: nil,
      value: amount,
      nonce: nonce,
      chain_id: 4,
      gas_price: EthereumPay.Gas.current_price
    }
  end

  defp request_nonce do
    nonce = NonceManager.nonce()
    NonceManager.set(nonce + 1)
    nonce
  end

  defp send_transaction(private_key, amount, receiver) do
    nonce = Mutex.under(EthereumPay.Mutex, :transaction, &request_nonce/0) 

    build(receiver, amount |> eth_to_wei, nonce)
    |> sign(private_key)
    |> hex_encode
    |> send_raw
  end

  def send(transaction_data) do
    pv_key = Application.fetch_env!(:ethereum_pay, :private_key)
    send_transaction(pv_key, transaction_data[:amount], transaction_data[:wallet])
  end

end

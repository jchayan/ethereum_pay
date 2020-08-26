defmodule TransactionTest do
  use ExUnit.Case, async: true
  doctest EthereumPay.Transaction

  alias EthereumPay.Transaction, as: Transaction

  setup_all do
    sender = %{
      address: Application.fetch_env!(:ethereum_pay, :wallet_address),
      private_key: Application.fetch_env!(:ethereum_pay, :private_key)
    }

    {:ok, sender: sender}
  end

  setup_all do
    {:ok, receiver: "0x00eFF82d69Adbb78702E2F501B707c104dcE88E5"}
  end

  test "sends transaction", state do
    amount = 0.001
    {status, tx} = Transaction.send(state[:sender], state[:receiver], amount)
    assert status == :ok
    assert Regex.match?(~r/^0x([A-Fa-f0-9]{64})\z/, tx)

  end
end

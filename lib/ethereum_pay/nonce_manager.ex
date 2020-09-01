defmodule EthereumPay.NonceManager do
  use GenServer

  @run_every 5 * 60 * 1000

  def start_link(_arg) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    :ets.new(:nonce_registry, [:set, :public, :named_table])

    schedule_work()
    {:ok, state}
  end

  def handle_info(:work, state) do
    schedule_work()
    {:noreply, state}
  end

  defp schedule_work() do
    Mutex.under(EthereumPay.Mutex, :transaction, &sync/0)
    Process.send_after(self(), :work, @run_every)
  end

  defp to_number(hex) do
    hex |> String.slice(2..-1) |> Integer.parse(16) |> elem(0)
  end

  defp address, do: Application.fetch_env!(:ethereum_pay, :wallet_address)

  defp fetch do
    case Ethereumex.HttpClient.eth_get_transaction_count(address(), "pending") do
      {:ok, tx_count} -> {:ok, to_number(tx_count)}
      error -> error
    end
  end

  def sync do
    {:ok, nonce} = fetch()
    set(nonce)
  end

  def set(nonce) do
    :ets.insert(:nonce_registry, {"nonce", nonce})
  end

  def nonce do
    :ets.lookup(:nonce_registry, "nonce") |> Enum.at(0) |> elem(1)
  end

end

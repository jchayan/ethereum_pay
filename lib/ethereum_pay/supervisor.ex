defmodule EthereumPay.Supervisor do
  use Supervisor

  def start_link(_opts) do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(_arg) do
    Supervisor.init([ EthereumPay.Server ], strategy: :one_for_one)
  end
end

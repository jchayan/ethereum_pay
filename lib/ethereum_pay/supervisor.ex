defmodule EthereumPay.Supervisor do
  use Supervisor

  def start_link(_opts) do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(_arg) do
    children = [
      EthereumPay.Server,
      { Mutex, name: EthereumPay.Mutex },
      { EthereumPay.NonceManager, name: EthereumPay.NonceManager },
      { Task.Supervisor, name: EthereumPay.TaskSupervisor }
    ]
    Supervisor.init(children, strategy: :one_for_one, max_seconds: 10)
  end
end

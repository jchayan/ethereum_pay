defmodule EthereumPay.BulkTransactions do

  alias EthereumPay.Transaction, as: Transaction

  defp task_result(result) when result == nil, do: {:exit, :timeout}
  defp task_result({_, result}), do: result

  defp filter_tasks(tasks, status) do
    tasks
    |> Enum.filter(&(&1 |> elem(0) == status))
    |> Keyword.get_values(status)
  end

  defp failed_tasks(tasks), do: filter_tasks(tasks, :exit)
  defp successful_tasks(tasks), do: filter_tasks(tasks, :ok)

  def send(transactions) do
    stream = Task.Supervisor.async_stream_nolink(EthereumPay.TaskSupervisor, transactions, Transaction, :send, [])
    tasks = stream |> Enum.map(&task_result/1)

    {:ok, %{ error: tasks |> failed_tasks, success: tasks |> successful_tasks }}
  end

end

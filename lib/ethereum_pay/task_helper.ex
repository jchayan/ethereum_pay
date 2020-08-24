defmodule EthereumPay.TaskHelper do

  defdelegate tx_count(address), to: ETH.TransactionQueries, as: :get_transaction_count
  defdelegate balance(address), to: ETH.Query, as: :get_balance
  defdelegate gas_price, to: EthereumPay.Gas, as: :current_price

  def address_tasks(address) do
    balance = (fn -> balance(address) |> elem(1) end) |> Task.async
    tx_count = (fn -> tx_count(address) |> elem(1) end) |> Task.async
    gas_price = (fn -> gas_price() end) |> Task.async

    task_list = [balance, tx_count, gas_price]
    tasks = Task.yield_many(task_list) |> Enum.map(&task_result/1)

    %{ error: tasks |> failed_tasks, success: tasks |> successful_tasks }
  end

  defp task_result(result) when result == nil, do: {:exit, :timeout}
  defp task_result({_, result}), do: result

  defp failed_tasks(tasks) do
    tasks
    |> Enum.filter(&(&1 |> elem(0) == :exit))
    |> Keyword.get_values(:exit)
  end

  defp successful_tasks(tasks) do
    tasks
    |> Enum.filter(&(&1 |> elem(0) == :ok))
    |> Keyword.get_values(:ok)
  end

end

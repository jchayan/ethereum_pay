defmodule EthereumPay.Tasks do

  defmacro __using__(_opts) do
    quote do

      defdelegate tx_count(address), to: ETH.TransactionQueries, as: :get_transaction_count
      defdelegate gas_price, to: EthereumPay.Gas, as: :current_price

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

      def transaction_data(address) do
        tx_count  = (fn -> tx_count(address) |> elem(1) end) |> Task.async
        gas_price = (fn -> gas_price() end) |> Task.async

        tasks = Task.yield_many([tx_count, gas_price]) |> Enum.map(&task_result/1)

        %{ error: tasks |> failed_tasks, success: tasks |> successful_tasks }
      end
    end
  end

end

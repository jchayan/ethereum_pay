defmodule EthereumPay.Server do
  use Maru.Server, otp_app: :ethereum_pay
end

defmodule EthereumPay.Router do
  use EthereumPay.Server
  import Plug.Conn

  alias EthereumPay.Transaction, as: Transaction
  alias EthereumPay.BulkTransactions, as: BulkTransactions

  get "/ok" do
    :timer.sleep(1000)
    conn |> text("ok")
  end

  params do
    requires :wallet, type: String
    requires :amount, type: Float
  end

  # POST - /send_transaction {wallet, amount}
  post "/send_transaction" do
    case Transaction.send(params) do
      {:error, error} ->
        conn |> put_status(500) |> json(error)
      {:ok, tx_id} ->
        conn |> json(%{ tx_id: tx_id })
      result ->
        conn |> put_status(500) |> json(%{error: result})
    end
  end

  params do
    requires :transactions, type: List do
      requires :wallet, type: String
      requires :amount, type: Float
    end
  end

  # POST - /send_transactions [{wallet, amount}...]
  post "/send_transactions" do
    case BulkTransactions.send(params[:transactions]) do
      %{error: error} ->
        conn |> put_status(500) |> json(error)
      {:ok, data} ->
        conn |> json(data)
      result ->
        conn |> put_status(500) |> json(%{error: result})
    end
  end

end

defmodule EthereumPay.API do
  use EthereumPay.Server

  before do
    plug Plug.Logger
  end

  plug Plug.Parsers,
    pass: ["*/*"],
    json_decoder: Poison,
    parsers: [:json]

  mount EthereumPay.Router

  # rescue_from :all, as: e do
  #   conn |> put_status(500) |> json(e)
  # end
end

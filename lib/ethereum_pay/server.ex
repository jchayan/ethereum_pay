defmodule EthereumPay.Server do
  use Maru.Server, otp_app: :ethereum_pay
end

defmodule EthereumPay.Router do
  use EthereumPay.Server
  import Plug.Conn

  alias EthereumPay.Transaction, as: Transaction

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
    sender = %{
      address: Application.fetch_env!(:ethereum_pay, :wallet_address),
      private_key: Application.fetch_env!(:ethereum_pay, :private_key)
    }

    result = Transaction.send(sender, params[:wallet], params[:amount])

    case result do
      {:error, error} ->
        conn |> put_status(500) |> json(error)
      {:ok, tx} ->
        conn |> json(%{ tx: tx })
      _ ->
        conn |> put_status(500) |> json(%{error: "unknown"})
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

  rescue_from :all, as: e do
    conn |> put_status(500) |> json(e)
  end
end

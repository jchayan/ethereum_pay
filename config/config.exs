import Config

config :ethereum_pay, EthereumPay.Server,
  adapter: Plug.Adapters.Cowboy,
  plug: EthereumPay.API,
  scheme: :http

config :ethereum_pay,
  maru_servers: [EthereumPay.Server]

config :ethereumex,
  http_options: [timeout: 8000, recv_timeout: 10000]

config :maru,
  json_library: Poison

import_config "#{Mix.env()}.exs"
import_config "wallet.secret.exs"

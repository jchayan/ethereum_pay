import Config

config :ethereumex,
  url: "https://rinkeby.infura.io/v3/eb26b90708824857b85c94c8692cd17c"

config :ethereum_pay, EthereumPay.Server,
  adapter: Plug.Adapters.Cowboy,
  plug: EthereumPay.API,
  scheme: :http,
  port: 8800

# EthereumPay

A high-performance Elixir server for handling concurrent Ethereum payment transactions. This service provides a simple HTTP API to send both single and bulk Ethereum transactions, with built-in USD/ETH conversion and gas price optimization.

## Features

- 🚀 **High Concurrency** - Built on Elixir/OTP for excellent concurrent transaction handling
- 💸 **USD to ETH Conversion** - Automatic currency conversion using CryptoCompare API
- ⛽ **Dynamic Gas Pricing** - Smart gas price management using ETH Gas Station
- 🔄 **Bulk Transactions** - Support for sending multiple transactions concurrently
- 🔒 **Nonce Management** - Thread-safe transaction nonce handling
- 🌐 **RESTful API** - Simple HTTP interface for transaction processing

## Requirements

- Elixir ~> 1.9.1
- Ethereum Node Access (defaults to Rinkeby testnet)
- [Infura](https://infura.io/) API Key (or other Ethereum node provider)

## Installation

1. Clone the repository
2. Install dependencies:

```bash
mix deps.get
```

3. Create `config/wallet.secret.exs` with your Ethereum credentials:

```elixir
import Config
config :ethereum_pay,
private_key: "YOUR_PRIVATE_KEY",
wallet_address: "YOUR_WALLET_ADDRESS"
```

## Configuration

The application can be configured through the following config files:

- `config/dev.exs` - Development environment
- `config/prod.exs` - Production environment
- `config/test.exs` - Test environment

Default port is 8800 for development and 80 for production.

## API Endpoints

### Send Single Transaction

```http
POST /send_transaction
Content-Type: application/json
{
  "wallet": "0x...",
  "amount": 100.50
}
```

### Send Bulk Transactions

```http
POST /send_transactions
Content-Type: application/json
{
  "transactions": [
    {
      "wallet": "0x...",
      "amount": 100.50
    },
    {
      "wallet": "0x...",
      "amount": 200.75
    }
  ]
}
```

## Key Dependencies

- `maru` - HTTP API framework
- `ethereumex` - Ethereum JSON-RPC client
- `eth` - Ethereum utilities
- `mutex` - Concurrency control
- `memoize` - API response caching
- `poison` - JSON encoding/decoding
- `httpoison` - HTTP client

## Architecture

The application is built on OTP principles with the following key components:

- `EthereumPay.Transaction` - Core transaction handling
- `EthereumPay.BulkTransactions` - Concurrent transaction processing
- `EthereumPay.NonceManager` - Transaction nonce management
- `EthereumPay.Exchange` - Currency conversion
- `EthereumPay.Gas` - Gas price management

## Development

Start the server in development mode:

```bash
mix run --no-halt
```

## Production

Build a release:

```bash
MIX_ENV=prod mix release
```

## License

MIT

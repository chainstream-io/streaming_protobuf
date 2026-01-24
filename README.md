# Chainstream Protobuf Schemas

Protobuf schema definitions for blockchain data streaming, supporting EVM, Solana, and Tron chains.

## Project Structure

```
streaming_protobuf/
├── common/                       # Cross-chain common definitions
│   ├── common.proto              # Base structures (Block, Transaction, etc.)
│   ├── trade_event.proto         # DEX trade events
│   ├── token_event.proto         # Token events
│   ├── balance_event.proto       # Balance change events
│   ├── dex_pool_event.proto      # DEX pool events
│   ├── transfer_event.proto      # Transfer events
│   ├── candlestick.proto         # Candlestick (OHLCV) data
│   ├── trade_stat.proto          # Trade statistics
│   ├── token_holding.proto       # Token holding data
│   ├── messages/                 # Generated Go code
│   └── python/common/            # Generated Python code
├── evm/                          # EVM chains (Ethereum, BSC, Base, etc.)
│   ├── block_message.proto       # Block and transaction structures
│   ├── transfers_message.proto   # Transfer message structures
│   ├── messages/                 # Generated Go code
│   └── python/evm/               # Generated Python code
├── solana/                       # Solana chain
│   ├── transfer_event.proto      # Transfer events
│   ├── transfer_processed_event.proto
│   ├── messages/                 # Generated Go code
│   └── python/solana/            # Generated Python code
├── tron/                         # Tron chain
│   ├── block_message.proto       # Block and transaction structures
│   ├── transfers_message.proto   # Transfer message structures
│   ├── messages/                 # Generated Go code
│   └── python/tron/              # Generated Python code
├── go.mod
├── go.sum
└── Makefile
```

## Kafka Topic Mapping

This section describes the mapping between Kafka topics and Protobuf message types for ChainStream blockchain data.

### General Notes

- **Chain Prefix**: Topic names are prefixed with chain identifiers: `sol.`, `bsc.`, `eth.`, `tron.`
- **Protobuf Package**: `io.chainstream.v1.*`
- **Common Dependency**: Most message types depend on base structures defined in `common/common.proto` (Block, Transaction, Instruction, DApp, etc.)

### Cross-Chain Topics (Solana / BSC / ETH)

The following Protobuf definitions apply to all supported chains (replace `{chain}` with `sol`, `bsc`, `eth`):

| Topic | Proto File | Message Type | Description |
|-------|------------|--------------|-------------|
| `{chain}.dex.trades` | `trade_event.proto` | `TradeEvents` | Raw DEX trade events |
| `{chain}.dex.trades.processed` | `trade_event.proto` | `TradeEvents` | Enriched with token price (USD/Native), suspicious flag |
| `{chain}.tokens` | `token_event.proto` | `TokenEvents` | Raw token events |
| `{chain}.tokens.created` | `token_event.proto` | `TokenEvents` | Token creation events |
| `{chain}.tokens.processed` | `token_event.proto` | `TokenEvents` | Enriched with description, image URL, social links |
| `{chain}.balances` | `balance_event.proto` | `BalanceEvents` | Raw balance change events |
| `{chain}.balances.processed` | `balance_event.proto` | `BalanceEvents` | Enriched with USD/Native value |
| `{chain}.dex.pools` | `dex_pool_event.proto` | `DexPoolEvents` | Raw DEX pool events |
| `{chain}.dex.pools.processed` | `dex_pool_event.proto` | `DexPoolEvents` | Enriched with liquidity (USD/Native) |
| `{chain}.token-supplies` | `token_supply_event.proto` | `TokenSupplyEvents` | Token supply events |
| `{chain}.token-supplies.processed` | `token_supply_event.proto` | `TokenSupplyEvents` | Enriched with market cap |
| `{chain}.transfers` | `transfer_event.proto` | `TransferEvents` | Token transfer events |
| `{chain}.transfers.processed` | `transfer_event.proto` | `TransferEvents` | Enriched with USD/Native value |
| `{chain}.token-prices` | `token_price_event.proto` | `TokenPriceEvents` | Token price events |
| `{chain}.candlesticks` | `candlestick.proto` | `CandlestickEvents` | OHLCV candlestick data |
| `{chain}.trade-stats` | `trade_stat.proto` | `TradeStatEvents` | Trade statistics |
| `{chain}.token-holdings` | `token_holding.proto` | `TokenHoldingEvents` | Token holding statistics |
| `{chain}.token-market-caps.processed` | `token_market_cap_event.proto` | `TokenMarketCapEvents` | Token market cap events |

### EVM-Specific Topics (BSC / ETH)

EVM chains use dedicated Protobuf definitions for transfer data:

| Topic | Proto File | Message Type | Description |
|-------|------------|--------------|-------------|
| `{chain}.v1.transfers.proto` | `evm/transfers_message.proto` | `TransfersMessage` | Raw EVM transfer messages |
| `{chain}.v1.transfers.processed.proto` | `evm/transfers_message.proto` | `TransfersMessage` | Processed EVM transfer messages |

**Dependencies**: `evm/block_message.proto` (BlockHeader, TransactionHeader, etc.)

### TRON-Specific Topics

TRON chain uses dedicated Protobuf definitions:

| Topic | Proto File | Message Type | Description |
|-------|------------|--------------|-------------|
| `tron.v1.transfers.proto` | `tron/transfers_message.proto` | `TransfersMessage` | Raw TRON transfer messages |
| `tron.v1.transfers.processed.proto` | `tron/transfers_message.proto` | `TransfersMessage` | Processed TRON transfer messages |

**Dependencies**: `tron/block_message.proto` (BlockHeader, TransactionHeader, etc.)

## Building Code

### Prerequisites

```bash
# macOS
brew install protobuf

# Install Go plugin
go install google.golang.org/protobuf/cmd/protoc-gen-go@latest

# Ensure protoc-gen-go is in PATH
export PATH="$PATH:$(go env GOPATH)/bin"
```

### Build Commands

```bash
# Generate all code
make all

# Generate individually
make generate_common
make generate_evm
make generate_solana
make generate_tron

# Clean generated files
make clean
```

## Usage in Go Projects

### Installation

```bash
go get github.com/chainstream/streaming_protobuf/v1
```

### Example

```go
package main

import (
    "google.golang.org/protobuf/proto"
    
    common "github.com/chainstream/streaming_protobuf/v1/common/messages"
    evm "github.com/chainstream/streaming_protobuf/v1/evm/messages"
    solana "github.com/chainstream/streaming_protobuf/v1/solana/messages"
    tron "github.com/chainstream/streaming_protobuf/v1/tron/messages"
)

func main() {
    // Parse trade event from Kafka message
    tradeEvents := &common.TradeEvents{}
    proto.Unmarshal(kafkaMessage, tradeEvents)
    
    for _, event := range tradeEvents.Events {
        fmt.Printf("Trade: %s\n", event.Trade.PoolAddress)
    }
}
```

## Usage in Python Projects

### Option 1: Git Submodule

```bash
git submodule add https://github.com/chainstream/streaming_protobuf.git streaming_protobuf
git submodule update --init --recursive
```

Add symlinks to your project:

```bash
ln -s streaming_protobuf/common/python/common ./common
ln -s streaming_protobuf/evm/python/evm ./evm 
ln -s streaming_protobuf/solana/python/solana ./solana
ln -s streaming_protobuf/tron/python/tron ./tron
```

### Install Dependencies

```bash
pip install protobuf
```

### Example

```python
from common import trade_event_pb2, balance_event_pb2
from evm import transfers_message_pb2

# Parse trade events from Kafka message
trade_events = trade_event_pb2.TradeEvents()
trade_events.ParseFromString(kafka_message)

for event in trade_events.events:
    print(f"Trade: {event.trade.pool_address}")
```

## Message Types

### Common (Cross-Chain)

| Message | Description |
|---------|-------------|
| `Block` | Block information |
| `Transaction` | Transaction information |
| `Instruction` | Instruction details |
| `DApp` | DApp information |
| `TradeEvent` | DEX trade event |
| `TokenEvent` | Token event |
| `BalanceEvent` | Balance change event |
| `DexPoolEvent` | DEX pool event |
| `TransferEvent` | Transfer event |
| `CandlestickEvent` | OHLCV candlestick |
| `TradeStatEvent` | Trade statistics |
| `TokenHoldingEvent` | Token holding data |

### EVM

| Message | Description |
|---------|-------------|
| `BlockHeader` | Block header information |
| `TransactionHeader` | Transaction header information |
| `Transfer` | Token transfer |
| `TransfersMessage` | Transfer message collection |
| `TokenInfo` | Token information |

### Tron

| Message | Description |
|---------|-------------|
| `BlockHeader` | Block header information |
| `TransactionHeader` | Transaction header information |
| `Transfer` | Token transfer |
| `TransfersMessage` | Transfer message collection |

## License

MIT

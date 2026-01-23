# Chainstream Protobuf Schemas

Protobuf schema definitions for blockchain data streaming, supporting EVM, Solana, and Tron chains.

## Project Structure

```
streaming_protobuf/
├── evm/                          # EVM chains (Ethereum, BSC, Base, etc.)
│   ├── block_message.proto       # Block and transaction structures
│   ├── transfers_message.proto   # Transfer message structures
│   ├── messages/                 # Generated Go code
│   └── python/evm/               # Generated Python code
├── solana/                       # Solana chain
│   ├── common.proto              # Common structure definitions
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
    
    evm "github.com/chainstream/streaming_protobuf/v1/evm/messages"
    solana "github.com/chainstream/streaming_protobuf/v1/solana/messages"
    tron "github.com/chainstream/streaming_protobuf/v1/tron/messages"
)

func main() {
    // EVM block header
    header := &evm.BlockHeader{
        Hash:   "0x...",
        Number: 12345678,
    }
    
    // Serialize
    data, _ := proto.Marshal(header)
    
    // Deserialize
    newHeader := &evm.BlockHeader{}
    proto.Unmarshal(data, newHeader)
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
from evm import block_message_pb2, transfers_message_pb2
from solana import transfer_event_pb2

# Create message
header = block_message_pb2.BlockHeader()
header.Hash = "0x..."
header.Number = 12345678

# Serialize
data = header.SerializeToString()

# Deserialize
new_header = block_message_pb2.BlockHeader()
new_header.ParseFromString(data)

print(f"Block: {new_header.Number}")
```

## Message Types

### EVM

| Message | Description |
|---------|-------------|
| `BlockHeader` | Block header information |
| `TransactionHeader` | Transaction header information |
| `Transfer` | Token transfer |
| `TransfersMessage` | Transfer message collection |
| `TokenInfo` | Token information |

### Solana

| Message | Description |
|---------|-------------|
| `Block` | Block information |
| `Transaction` | Transaction information |
| `TransferEvent` | Transfer event |
| `TransferProcessed` | Processed transfer data |

### Tron

| Message | Description |
|---------|-------------|
| `BlockHeader` | Block header information |
| `TransactionHeader` | Transaction header information |
| `Transfer` | Token transfer |
| `TransfersMessage` | Transfer message collection |

## License

MIT

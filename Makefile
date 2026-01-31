MODULE = github.com/chainstream-io/streaming_protobuf

all: generate_common generate_evm generate_solana generate_tron

generate_common:
	protoc \
	-I=. \
	--go_out=common/messages \
	--go_opt=paths=source_relative \
	--go_opt="Mcommon/common.proto=$(MODULE)/common/messages;common_messages" \
	--go_opt="Mcommon/balance_event.proto=$(MODULE)/common/messages;common_messages" \
	--go_opt="Mcommon/balance_processed_event.proto=$(MODULE)/common/messages;common_messages" \
	--go_opt="Mcommon/candlestick.proto=$(MODULE)/common/messages;common_messages" \
	--go_opt="Mcommon/candlestick_agg.proto=$(MODULE)/common/messages;common_messages" \
	--go_opt="Mcommon/dex_pool_event.proto=$(MODULE)/common/messages;common_messages" \
	--go_opt="Mcommon/dex_pool_processed_event.proto=$(MODULE)/common/messages;common_messages" \
	--go_opt="Mcommon/price.proto=$(MODULE)/common/messages;common_messages" \
	--go_opt="Mcommon/token_event.proto=$(MODULE)/common/messages;common_messages" \
	--go_opt="Mcommon/token_holding.proto=$(MODULE)/common/messages;common_messages" \
	--go_opt="Mcommon/token_market_cap_event.proto=$(MODULE)/common/messages;common_messages" \
	--go_opt="Mcommon/token_price_event.proto=$(MODULE)/common/messages;common_messages" \
	--go_opt="Mcommon/token_processed_event.proto=$(MODULE)/common/messages;common_messages" \
	--go_opt="Mcommon/token_supply_event.proto=$(MODULE)/common/messages;common_messages" \
	--go_opt="Mcommon/token_supply_processed_event.proto=$(MODULE)/common/messages;common_messages" \
	--go_opt="Mcommon/trade_event.proto=$(MODULE)/common/messages;common_messages" \
	--go_opt="Mcommon/trade_processed_event.proto=$(MODULE)/common/messages;common_messages" \
	--go_opt="Mcommon/trade_stat.proto=$(MODULE)/common/messages;common_messages" \
	--go_opt="Mcommon/trade_stat_agg.proto=$(MODULE)/common/messages;common_messages" \
	--go_opt="Mcommon/transfer_event.proto=$(MODULE)/common/messages;common_messages" \
	--go_opt="Mcommon/transfer_processed_event.proto=$(MODULE)/common/messages;common_messages" \
	$(shell find ./common -type f -name '*.proto')
	@mv common/messages/common/*.pb.go common/messages/ 2>/dev/null || true
	@rmdir common/messages/common 2>/dev/null || true
	protoc \
	-I=. \
	--python_out="common/python" \
	$(shell find ./common -type f -name '*.proto')

generate_evm:
	protoc \
	-I=. \
	--go_out=evm/messages \
	--go_opt=paths=source_relative \
	--go_opt="Mevm/block_message.proto=$(MODULE)/evm/messages;evm_messages" \
	--go_opt="Mevm/transfers_message.proto=$(MODULE)/evm/messages;evm_messages" \
	$(shell find ./evm -type f -name '*.proto')
	@mv evm/messages/evm/*.pb.go evm/messages/ 2>/dev/null || true
	@rmdir evm/messages/evm 2>/dev/null || true
	protoc \
    	-I=. \
		--python_out="evm/python" \
    	$(shell find ./evm -type f -name '*.proto')

generate_solana:
	protoc \
	-I=. \
	--go_out=solana/messages \
	--go_opt=paths=source_relative \
	--go_opt="Mcommon/common.proto=$(MODULE)/common/messages;common_messages" \
	--go_opt="Mcommon/transfer_processed_event.proto=$(MODULE)/common/messages;common_messages" \
	--go_opt="Msolana/transfer_event.proto=$(MODULE)/solana/messages;solana_messages" \
	--go_opt="Msolana/transfer_processed_event.proto=$(MODULE)/solana/messages;solana_messages" \
	$(shell find ./solana -type f -name '*.proto')
	@mv solana/messages/solana/*.pb.go solana/messages/ 2>/dev/null || true
	@rmdir solana/messages/solana 2>/dev/null || true
	protoc \
    	-I=. \
		--python_out="solana/python" \
	$(shell find ./solana -type f -name '*.proto')

 generate_tron:
	protoc \
	-I=. \
	--go_out=tron/messages \
	--go_opt=paths=source_relative \
	--go_opt="Mevm/block_message.proto=$(MODULE)/evm/messages;evm_messages" \
	--go_opt="Mtron/block_message.proto=$(MODULE)/tron/messages;tron_messages" \
	--go_opt="Mtron/transfers_message.proto=$(MODULE)/tron/messages;tron_messages" \
	$(shell find ./tron -type f -name '*.proto')
	@mv tron/messages/tron/*.pb.go tron/messages/ 2>/dev/null || true
	@rmdir tron/messages/tron 2>/dev/null || true
	protoc \
		-I=. \
		--python_out="tron/python" \
		$(shell find ./tron -type f -name '*.proto')

clean:
	find . -name "*.pb.go" -type f -delete
	find . -name "*_pb2.py" -type f -delete

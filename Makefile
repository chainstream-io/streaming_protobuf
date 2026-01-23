all: generate_evm generate_solana generate_tron

generate_evm:
	protoc \
	-I=. \
	--go_out=. \
	--go_opt="Mevm/block_message.proto=evm/messages;evm_messages" \
	--go_opt="Mevm/transfers_message.proto=evm/messages;evm_messages" \
	$(shell find ./evm -type f -name '*.proto')
	protoc \
	-I=. \
	--python_out="evm/python" \
	$(shell find ./evm -type f -name '*.proto')

generate_solana:
	protoc \
	-I=. \
	--go_out=. \
	--go_opt="Msolana/common.proto=solana/messages;solana_messages" \
	--go_opt="Msolana/transfer_event.proto=solana/messages;solana_messages" \
	--go_opt="Msolana/transfer_processed_event.proto=solana/messages;solana_messages" \
	$(shell find ./solana -type f -name '*.proto' ! -path '*/corecast/*')
	protoc \
	-I=. \
	--python_out="solana/python" \
	$(shell find ./solana -type f -name '*.proto' ! -path '*/corecast/*')

generate_tron:
	protoc \
	-I=. \
	--go_out=. \
	--go_opt="Mtron/block_message.proto=tron/messages;tron_messages" \
	--go_opt="Mtron/transfers_message.proto=tron/messages;tron_messages" \
	$(shell find ./tron -type f -name '*.proto')
	protoc \
	-I=. \
	--python_out="tron/python" \
	$(shell find ./tron -type f -name '*.proto')

clean:
	find . -name "*.pb.go" -type f -delete
	find . -name "*_pb2.py" -type f -delete

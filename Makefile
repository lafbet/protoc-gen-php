build:
	docker buildx build --platform linux/amd64 -t protoc-gen-php:latest . --load

generate:
	docker run --rm --platform=linux/amd64 -v "./proto:/proto" -v "./generated:/generated" protoc-gen-php \
		--php_out=/generated \
		--grpc_out=/generated \
		wallet.proto
#!/bin/sh

set -e

# Если нет аргументов — покажем справку
if [ "$#" -eq 0 ]; then
  echo "Использование: docker run ... [protoc options and .proto files]"
  echo
  echo "Пример:"
  echo "  docker run --rm -v \$(pwd)/proto:/proto -v \$(pwd)/gen:/gen image-name \\"
  echo "     -I /proto --php_out=/gen --grpc_out=/gen /proto/file1.proto /proto/file2.proto"
  exit 1
fi

# Проверим, что хотя бы один .proto файл передан
PROTO_FILES=$(echo "$@" | grep -oE '[^ ]+\.proto' || true)
if [ -z "$PROTO_FILES" ]; then
  echo "⚠️  Внимание: не предоставлено .proto файлов в аргументах. protoc не будет выполнен."
fi

echo "🚀 Запуск protoc для генерации gRPC и PHP файлов из ${PROTO_FILES}"

# Выполним protoc с аргументами, переданными пользователем
exec protoc --proto_path=/proto --plugin=protoc-gen-grpc=/usr/local/bin/grpc_php_plugin "$@"
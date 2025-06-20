Докер образ для генерации `protobuf` под `php`.

### Зачем?

Потому что генерация `protobuf` под `php` требует плагин, который нужно собирать долго и неудобно. Этот образ содержит все необзодимые зависимости и позволяет сгенерировать `protobuf` быстро и без лишних сложностей прямо в контейнере.

### Использование

```shell
docker run --rm --platform=linux/amd64 \
    -v "./your_proto_base_path:/proto" \
    -v "./your_pb_output_path:/generated" \
    ghcr.io/lafbet/protoc-gen-php:latest \
		--php_out=/generated \
		--grpc_out=/generated \
		my_service.proto
```

В команде используется два volume:

- proto - папка с proto-файлами.
- generated - папка под сгенерированный protobuf.

> Рекомендуется записать готовые команды в `Makefile` и выполнять при изменении proto-файлов

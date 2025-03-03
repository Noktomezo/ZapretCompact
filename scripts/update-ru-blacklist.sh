#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
OUTPUT_FILE="$ROOT_DIR/hosts/list-russia.txt"
RU_BLACKLIST_API="https://reestr.rublacklist.net/api/v3/domains/"

mkdir -p "$(dirname "$OUTPUT_FILE")"

echo "🔍 Извлечение доменов из API..."
curl -s "$RU_BLACKLIST_API" | jq -r '.[]' > "$OUTPUT_FILE"

DOMAIN_COUNT=$(wc -l < "$OUTPUT_FILE")
echo "💾 Успешно сохранено $DOMAIN_COUNT доменов в $OUTPUT_FILE"

if [ "$DOMAIN_COUNT" -eq 0 ]; then
  echo "⚠️ Внимание: домены не были извлечены или файл пуст!"
  exit 1
fi

echo "✅ Обновление черного списка успешно завершено."
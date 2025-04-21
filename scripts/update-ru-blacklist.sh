#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
OUTPUT_FILE="$ROOT_DIR/hosts/russia-blocked.txt"

ANTIFILTER_MAIN_LIST="https://antifilter.download/list/domains.lst"
ANTIFILTER_COMMUNITY_LIST="https://community.antifilter.download/list/domains.lst"
RE_FILTER_LIST="https://raw.githubusercontent.com/1andrevich/Re-filter-lists/refs/heads/main/domains_all.lst"

mkdir -p "$(dirname "$OUTPUT_FILE")"

echo "🔍 Извлечение доменов из API..."
sort -u \
  <(curl -s "$ANTIFILTER_MAIN_LIST") \
  <(curl -s "$ANTIFILTER_COMMUNITY_LIST") \
  <(curl -s "$RE_FILTER_LIST") \
  > "$OUTPUT_FILE"

DOMAIN_COUNT=$(wc -l < "$OUTPUT_FILE")
echo "💾 Успешно сохранено $DOMAIN_COUNT доменов в $OUTPUT_FILE"

if [ "$DOMAIN_COUNT" -eq 0 ]; then
  echo "⚠️ Внимание: домены не были извлечены или файл пуст!"
  exit 1
fi

echo "✅ Обновление черного списка успешно завершено."
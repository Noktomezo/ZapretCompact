#!/usr/bin/env bash
set -e -u -o pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "${SCRIPT_DIR}")"
OUTPUT_FILE="${ROOT_DIR}/hosts/russia-blocked.txt"

ANTIFILTER_MAIN_LIST="https://antifilter.download/list/domains.lst"
ANTIFILTER_COMMUNITY_LIST="https://community.antifilter.download/list/domains.lst"
RE_FILTER_LIST="https://raw.githubusercontent.com/1andrevich/Re-filter-lists/refs/heads/main/domains_all.lst"

mkdir -p "$(dirname "${OUTPUT_FILE}")"
PREV_DOMAIN_COUNT=$(wc -l < "${OUTPUT_FILE}")

echo "🔍 Извлечение доменов из API..."
sort -u \
  <(curl -L -H "Accept-Encoding: gzip" -k --fail --retry 4 -# "${ANTIFILTER_MAIN_LIST}") \
  <(curl -L -H "Accept-Encoding: gzip" -k --fail --retry 4 -# "${ANTIFILTER_COMMUNITY_LIST}") \
  <(curl -L -H "Accept-Encoding: gzip" -k --fail --retry 4 -# "${RE_FILTER_LIST}") \
  > "${OUTPUT_FILE}"

NEW_DOMAIN_COUNT=$(wc -l < "${OUTPUT_FILE}")

(( "${NEW_DOMAIN_COUNT}" > 0 )) || {
  echo "⚠️ Ошибка: не удалось получить данные ни из одного источника!" >&2
  exit 1
}

if [ "${PREV_DOMAIN_COUNT}" -ne "${NEW_DOMAIN_COUNT}" ]; then
  echo "💾 Обновление данных: ${PREV_DOMAIN_COUNT} → ${NEW_DOMAIN_COUNT} доменов"
else
  echo "ℹ️ Количество доменов не изменилось: ${NEW_DOMAIN_COUNT}"
fi

echo "✅ Обновление черного списка успешно завершено."

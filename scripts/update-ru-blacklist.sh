#!/usr/bin/env bash
set -e -u -o pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "${SCRIPT_DIR}")"
OUTPUT_FILE="${ROOT_DIR}/hosts/russia-blocked.txt"


ANTIFILTER_IPRESOLVE_IPS_LIST="https://antifilter.download/list/ipresolve.lst"
ANTIFILTER_ALLYOUNEED_IPS_LIST="https://antifilter.download/list/allyouneed.lst"
ANTIFILTER_COMMUNITY_IPS_LIST="https://community.antifilter.download/list/community.lst"
RE_FILTER_IPSUM_LIST="https://raw.githubusercontent.com/1andrevich/Re-filter-lists/refs/heads/main/ipsum.lst"

# ANTIFILTER_MAIN_LIST="https://antifilter.download/list/domains.lst"
# ANTIFILTER_COMMUNITY_LIST="https://community.antifilter.download/list/domains.lst"
# RE_FILTER_LIST="https://raw.githubusercontent.com/1andrevich/Re-filter-lists/refs/heads/main/domains_all.lst"

mkdir -p "$(dirname "${OUTPUT_FILE}")"
PREV_DOMAIN_COUNT=$(wc -l < "${OUTPUT_FILE}")

echo "🔍 Извлечение IP-адресов из API..."
sort -u \
  <(curl -L -k --fail --retry 4 -# "${ANTIFILTER_IPRESOLVE_IPS_LIST}") \
  <(curl -L -k --fail --retry 4 -# "${ANTIFILTER_ALLYOUNEED_IPS_LIST}") \
  <(curl -L -k --fail --retry 4 -# "${ANTIFILTER_COMMUNITY_IPS_LIST}") \
  <(curl -L -k --fail --retry 4 -# "${RE_FILTER_IPSUM_LIST}") \
  > "${OUTPUT_FILE}"

NEW_DOMAIN_COUNT=$(wc -l < "${OUTPUT_FILE}")

(( "${NEW_DOMAIN_COUNT}" > 0 )) || {
  echo "⚠️ Ошибка: не удалось получить данные ни из одного источника!" >&2
  exit 1
}

if [ "${PREV_DOMAIN_COUNT}" -ne "${NEW_DOMAIN_COUNT}" ]; then
  echo "💾 Обновление IP-адресов: ${PREV_DOMAIN_COUNT} → ${NEW_DOMAIN_COUNT}"
else
  echo "ℹ️ Количество IP-адресов не изменилось: ${NEW_DOMAIN_COUNT}"
fi

echo "✅ Обновление черного списка успешно завершено."

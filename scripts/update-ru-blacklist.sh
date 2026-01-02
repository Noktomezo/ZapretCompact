#!/usr/bin/env bash
set -e -u -o pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "${SCRIPT_DIR}")"
OUTPUT_FILE="${ROOT_DIR}/hosts/ipset-russia-blocked.txt"

RU_BLOCKED_IPSET="https://cdn.jsdelivr.net/gh/runetfreedom/russia-blocked-geoip@release/text/ru-blocked.txt"
RU_BLOCKED_COMMUNITY_IPSET="https://cdn.jsdelivr.net/gh/runetfreedom/russia-blocked-geoip@release/text/ru-blocked-community.txt"
RE_FILTER_IPSET="https://cdn.jsdelivr.net/gh/runetfreedom/russia-blocked-geoip@release/text/re-filter.txt"

download_list() {
  local url="$1"
  curl -L -k --fail --retry 4 --retry-delay 2 --retry-all-errors --connect-timeout 10 -# "${url}"
}

mkdir -p "$(dirname "${OUTPUT_FILE}")"
[ ! -f "${OUTPUT_FILE}" ] && touch "${OUTPUT_FILE}"

PREV_DOMAIN_COUNT=$(wc -l <"${OUTPUT_FILE}")

echo "Извлечение IP-адресов из API..."

sort -u -S 50% \
  <(download_list "${RU_BLOCKED_IPSET}") \
  <(download_list "${RU_BLOCKED_COMMUNITY_IPSET}") \
  <(download_list "${RE_FILTER_IPSET}") \
  >"${OUTPUT_FILE}"

NEW_DOMAIN_COUNT=$(wc -l <"${OUTPUT_FILE}")

(("${NEW_DOMAIN_COUNT}" > 0)) || {
  echo "Ошибка: не удалось получить данные ни из одного источника!" >&2
  exit 1
}

if [ "${PREV_DOMAIN_COUNT}" -ne "${NEW_DOMAIN_COUNT}" ]; then
  echo "Обновление IP-адресов: ${PREV_DOMAIN_COUNT} -> ${NEW_DOMAIN_COUNT}"
else
  echo "Количество IP-адресов не изменилось: ${NEW_DOMAIN_COUNT}"
fi

echo "Обновление черного списка успешно завершено."

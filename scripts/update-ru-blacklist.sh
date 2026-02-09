#!/usr/bin/env bash
set -e -u -o pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "${SCRIPT_DIR}")"
OUTPUT_FILE="${ROOT_DIR}/hosts/ipset-russia-blocked.txt"

RU_BLOCKED_IPSET="https://github.com/Noktomezo/RussiaFancyLists/raw/refs/heads/main/lists/ipsets/full-smart-and-cdn.lst"

download_list() {
  local url="$1"
  curl -f#SL -m 120 --connect-timeout 10 --retry 4 "${url}"
}

mkdir -p "$(dirname "${OUTPUT_FILE}")"
[ ! -f "${OUTPUT_FILE}" ] && touch "${OUTPUT_FILE}"

PREV_DOMAIN_COUNT=$(wc -l <"${OUTPUT_FILE}")

echo "Извлечение IP-адресов из API..."
sort -uV <(download_list "${RU_BLOCKED_IPSET}") >"${OUTPUT_FILE}"

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

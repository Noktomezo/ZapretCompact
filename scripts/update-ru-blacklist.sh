#!/usr/bin/env bash
set -e -u -o pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "${SCRIPT_DIR}")"
OUTPUT_FILE="${ROOT_DIR}/hosts/russia-blocked-ipset.txt"
CACHE_DIR="${ROOT_DIR}/.cache"
CACHE_TTL=86400

mkdir -p "${CACHE_DIR}"

load_cached() {
    local url="$1"
    local cache_file="${CACHE_DIR}/$(basename "${url}")"
    local max_retries=10
    local retry_delay=5

    if [ -f "${cache_file}" ] && [ "$(( $(date +%s) - $(stat -c %Y "${cache_file}") ))" -lt "${CACHE_TTL}" ]; then
        if [ -s "${cache_file}" ]; then
            echo "Использование кэша для: ${url}"
            cat "${cache_file}"
            return 0
        else
            echo "Предупреждение: пустой файл кэша найден для: ${url}, загрузка заново"
            rm -f "${cache_file}"
        fi
    fi

    echo "Загрузка: ${url}"
    local attempt=1
    while [ $attempt -le $max_retries ]; do
        if curl -L -k --fail --retry 4 --retry-delay 2 --retry-all-errors --connect-timeout 10 -# "${url}" | tee "${cache_file}"; then
            if [ -s "${cache_file}" ]; then
                return 0
            else
                echo "Ошибка: загружен пустой файл для: ${url}"
                rm -f "${cache_file}"
                return 1
            fi
        else
            local error_code=$?
            echo "Ошибка при загрузке (попытка $attempt/$max_retries, код ошибки: $error_code)"
            if [ $attempt -lt $max_retries ]; then
                echo "Повторная попытка через ${retry_delay} секунд..."
                sleep $retry_delay
            fi
            attempt=$((attempt + 1))
        fi
    done

    echo "Все попытки загрузки исчерпаны для: ${url}" >&2
    return 1
}

if [ ! -f "${OUTPUT_FILE}" ]; then
    touch "${OUTPUT_FILE}"
fi

ANTIFILTER_IPRESOLVE_IPS_LIST="https://antifilter.download/list/ipresolve.lst"
ANTIFILTER_ALLYOUNEED_IPS_LIST="https://antifilter.download/list/allyouneed.lst"
ANTIFILTER_COMMUNITY_IPS_LIST="https://community.antifilter.download/list/community.lst"
RE_FILTER_IPSUM_LIST="https://raw.githubusercontent.com/1andrevich/Re-filter-lists/refs/heads/main/ipsum.lst"

mkdir -p "$(dirname "${OUTPUT_FILE}")"
PREV_DOMAIN_COUNT=$(wc -l < "${OUTPUT_FILE}")

echo "Извлечение IP-адресов из API..."
sort -u -S 50% -T "${CACHE_DIR}" \
<(load_cached "${ANTIFILTER_IPRESOLVE_IPS_LIST}") \
<(load_cached "${ANTIFILTER_ALLYOUNEED_IPS_LIST}") \
<(load_cached "${ANTIFILTER_COMMUNITY_IPS_LIST}") \
<(load_cached "${RE_FILTER_IPSUM_LIST}") \
> "${OUTPUT_FILE}"

NEW_DOMAIN_COUNT=$(wc -l < "${OUTPUT_FILE}")

(( "${NEW_DOMAIN_COUNT}" > 0 )) || {
    echo "Ошибка: не удалось получить данные ни из одного источника!" >&2
    exit 1
}

if [ "${PREV_DOMAIN_COUNT}" -ne "${NEW_DOMAIN_COUNT}" ]; then
    echo "Обновление IP-адресов: ${PREV_DOMAIN_COUNT} -> ${NEW_DOMAIN_COUNT}"
else
    echo "Количество IP-адресов не изменилось: ${NEW_DOMAIN_COUNT}"
fi

echo "Обновление черного списка успешно завершено."

find "${CACHE_DIR}" -type f -mtime +7 -delete

#!/usr/bin/env bash

set -o errexit -o pipefail

function info() {
  echo "[INFO] $@"
}

function fatal() {
  echo "[FATAL] $@"
  exit 1
}

function gen_logs() {
  for (( n = 0; n < $2; n++ )); do
    echo "The quick brown fox jumps over the lazy dog." >> "./logs/$1"
  done
}

function rotate_logs() {
  file="./logs/$1"
  threshold="$2"
  new_file="${file}-$(date +%s)"
  lines_in_log="$(cat "${file}" | wc -l)"
  if [[ ${lines_in_log} -gt ${threshold} ]]; then
    mv "${file}" "${new_file}"
  fi
  info "The '${file}' has been renamed to '${new_file}'."
}

function clean_logs() {
  num_files="$(ls -1 ./logs/ | wc -l)"
  threshold="$1"
  if [[ ${num_files} -le ${threshold} ]]; then
    return 0
  fi
  files="$(ls -Acr ./logs/)"
  for file in ${files}; do
    info "Deleting the file './logs/${file}'."
    rm "./logs/${file}"
    num_files="$(ls -1 ./logs/ | wc -l)"
    if [[ ${num_files} -le ${threshold} ]]; then
      return 0
    fi
  done
}


if [[ $(id -u) -eq 0 ]]; then
  fatal "This script must be run as a non-root user."
fi

if [[ ! -d "./logs" ]]; then
  fatal "The 'logs' directory is not present."
fi

if [[ $# -lt 1 ]]; then
  fatal "Needs at least one argument, can be gen, rotate, or clean."
fi

if [[ "$1" == "gen" ]]; then
  gen_logs "earth-log" 50
fi

if [[ "$1" == "rotate" ]]; then
  rotate_logs "earth-log" 20
fi

if [[ "$1" == "clean" ]]; then
  clean_logs 5
fi

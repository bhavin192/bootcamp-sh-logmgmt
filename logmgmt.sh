#!/usr/bin/env bash

function info() {
  echo "[INFO] $@"
}

function fatal() {
  echo "[FATAL] $@"
  exit 1
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

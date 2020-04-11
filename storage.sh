#!/bin/bash
set -e

if [[ -n "$TRACE" ]]; then
  set -x;
fi

COMMAND=$1
LOCAL=${LOCAL:-/storage}
REMOTE="$AWS_BUCKET"

if [[ -n "$ENDPOINT_URL" ]]; then
  AWS="aws --endpoint-url $ENDPOINT_URL"
else
  AWS=aws
fi

function restore {
  echo "Restore $REMOTE => $LOCAL"
  $AWS s3 sync "$REMOTE" "$LOCAL"
}

function restore_empty {
  echo "Restore if empty"
  if [[ -z "$(find $LOCAL -type f)" ]]; then
    restore
  else
    echo "Volume not empty, skip"
  fi
}

function backup {
  echo "Backup $LOCAL => $REMOTE"
  $AWS s3 sync "$LOCAL" "$REMOTE" --delete
}

function backup_final {
  echo "Backup final"
  while ! backup; do
    echo "Backup failed, retry" 1>&2
    sleep 1
  done
  exit 0
}

function backup_loop {
  echo "Backup loop"
  trap backup_final SIGHUP SIGINT SIGTERM
  while true; do
    sleep ${BACKUP_INTERVAL:-300} &
    wait $!
    if [[ -n "$BACKUP_INTERVAL" ]]; then
      backup
    fi
  done
}

eval $COMMAND

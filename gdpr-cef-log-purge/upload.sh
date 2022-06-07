#!/usr/bin/env bash

set -euo pipefail

cd /gdpr/upload
while true; do
    echo "searching for gz files..."
    if list=$(find . -name "*.gz"); then
      count=$(echo "$list" | wc -w)
      echo "$count files found."
      dog metric post gdpr_cef_log.upload.q_size "$count"
      for f in $list; do
        aws s3api put-object --bucket bucket-name \
           --key "prod-logsearch/$f" \
           --body "$f"
        echo "done uploading $f to s3"
        rm -f "$f"
      done
    fi
    echo sleep 1m
    sleep 60
done

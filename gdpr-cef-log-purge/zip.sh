#!/usr/bin/env bash
## zip May 23

set -euo pipefail

cd /gdpr/zip
while true;
do
    echo "searching for filterd-log files..."
    count=$(find . -name "filtered*.log" | wc -l)
    echo "$count files found."
     dog metric post gdpr_cef_log.zip.q_size "$count"
    if list=$(find . -name "filtered*.log" | head -20 ); then
       echo "gzip $list..."
       echo "$list" | parallel --no-notice -a- -j3 gzip
       for f in $list; do
            mv "$f.gz" "/gdpr/upload/$f.gz"
       done
    fi
    echo sleep 5s
    sleep 5
done

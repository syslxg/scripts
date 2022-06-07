#!/usr/bin/env bash

set -euo pipefail

for date in $(ruby -r date -e '(Date.parse("2017/02/22") .. Date.parse("2017/11/30")).each {|d| printf("%d/%02d/%02d\n", d.year, d.month,d.day)}'); do
  echo search in "$date"
  aws s3 ls "s3://bucket-name/prod-logsearch/$date/"  | awk '{print $4}'> /tmp/post-check.txt
  a=$(grep -c '^cc_ng' /tmp/post-check.txt)
  b=$(grep -c '^filtered-cc_ng' /tmp/post-check.txt)
  echo "number of unfilted/filtered files: $a / $b"
  rm /tmp/post-check.txt
done

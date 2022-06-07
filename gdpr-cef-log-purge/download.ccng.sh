#!/usr/bin/env bash

set -euo pipefail

cd /gdpr

for date in $(ruby -r date -e '(Date.parse("2017/08/16") .. Date.parse("2017/08/21")).each {|d| printf("%d/%02d/%02d\n", d.year, d.month,d.day)}'); do
  dir=$(echo "$date" | sed 's/\//-/g')
  mkdir "$dir"

  for file in $(aws s3 ls "s3://bucket-name/prod-logsearch/$date/"  | awk '{print $4}' | grep '^cc_ng' ); do
    echo "-- downloading $file"

    aws s3api get-object --bucket bucket-name \
     --key "prod-logsearch/$date/$file" "$dir/$file"
  done
done

#!/usr/bin/env bash

set -euo pipefail

export from='2016/08/14'
export   to='2016/09/14'
for date in $(ruby -r date -e '(Date.parse(ENV["from"]) .. Date.parse(ENV["to"])).each {|d| printf("%d/%02d/%02d\n", d.year, d.month,d.day)}'); do
  for file in $(aws s3 ls "s3://bucket-name/prod-logsearch/$date/201"  | awk '{print $4}' ); do
    echo "$file"
    aws s3api restore-object --bucket bucket-name \
     --key "prod-logsearch/$date/$file" \
     --restore-request '{ "Days": 14, "GlacierJobParameters": { "Tier": "Bulk" }}'
  done
done

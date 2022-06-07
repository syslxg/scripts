#!/usr/bin/env bash

set -euo pipefail

## filter May 16

# to do : redo the 2017/08/16 to 08/21 later

export from='2016/08/14'
export   to='2016/09/14'
for date in $(ruby -r date -e '(Date.parse(ENV["from"]) .. Date.parse(ENV["to"])).each {|d| printf("%d/%02d/%02d\n", d.year, d.month,d.day)}');
do
    dir=$(echo "$date" | sed 's/\//-/g')
    cd "/gdpr/$dir"
    mkdir -p "/gdpr/upload/$date"
    mkdir -p "/gdpr/zip/$date"
    mkdir -p filtered
    for gzf in *.gz; do
      if ! gunzip "$gzf"; then
          echo "$date/$gzf" >> /gdpr/bad_gz.txt
          continue
      fi
      f=${gzf:0:-3}
      echo "-- filtering $f" | tee -a /gdpr/filter.log
      sed -e '/CEF.*suser=/d' "$f" > "filtered/filtered-$f"
      mv "filtered/filtered-${f}" "/gdpr/zip/$date/"
      aws s3api delete-object --bucket bucket-name \
         --key "prod-logsearch/$date/$f.gz"
      echo "done deleting $f.gz on s3"
      rm -f "$f"
      echo "done deleting local files"
    done
done

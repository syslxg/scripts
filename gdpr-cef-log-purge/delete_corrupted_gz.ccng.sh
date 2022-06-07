#!/usr/bin/env bash

set -euo pipefail

grep 'cc_ng.*.log.gz'  /gdpr/bad_gz.txt | sort | uniq | xargs -I {} aws s3 rm s3://bucket-name/prod-logsearch/{}

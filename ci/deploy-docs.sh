#!/usr/bin/env bash
# Build the documentation site and publish it to R2 (served at docs.nubosuite.tech
# by the nubo-docs Worker, source in docs-site/worker.js).
set -euo pipefail
cd "$(dirname "$0")/../docs-site"
. ../ci/rclone-env.sh
npm ci --no-audit --no-fund
npm run build
rclone sync dist "r2:nubo-docs" --fast-list --checksum
echo "Published to https://docs.nubosuite.tech"

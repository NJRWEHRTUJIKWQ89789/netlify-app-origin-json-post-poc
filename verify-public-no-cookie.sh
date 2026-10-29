#!/bin/sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
ENDPOINT='https://app.netlify.com/.netlify/functions/bitbucket-self-hosted'
EXPECTED='8c7b5c2dc5338aa032aabade6688c5e15bf6b99bad4a298f11da0d33ed2383cc'
OUT=${1:-"$ROOT/evidence/no-cookie-public-check"}
mkdir -p "$OUT"

STATUS=$(curl --disable --silent --show-error \
  --request POST \
  --cookie '' \
  --header 'Authorization:' \
  --header 'Origin: https://example.org' \
  --header 'Content-Type: text/plain' \
  --data-binary "@$ROOT/evidence/form-text-plain-body.txt" \
  --trace-ascii "$OUT/request.trace" \
  --dump-header "$OUT/response.headers" \
  --output "$OUT/response.json" \
  --write-out '%{http_code}' \
  "$ENDPOINT")

if command -v shasum >/dev/null 2>&1; then
  HASH=$(shasum -a 256 "$OUT/response.json" | awk '{print $1}')
else
  HASH=$(sha256sum "$OUT/response.json" | awk '{print $1}')
fi
[ "$STATUS" = 200 ]
[ "$HASH" = "$EXPECTED" ]
python3 -m json.tool "$OUT/response.json" > "$OUT/response.pretty.json"
printf 'PASS status=%s sha256=%s endpoint=%s\n' "$STATUS" "$HASH" "$ENDPOINT"

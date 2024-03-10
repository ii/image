#!/usr/bin/env sh

set -o errexit
set -o nounset

cd "$(git rev-parse --show-toplevel)" || exit 1
echo "$( \
    jq \
    --arg FULCIO_PUB "$(curl -sSL https://github.com/sigstore/root-signing/raw/main/targets/fulcio_v1.crt.pem | sed 's,$,\\n,g' | tr -d '\n')" \
    --arg REKOR_PUB "$(curl -sSL https://github.com/sigstore/root-signing/raw/main/targets/rekor.pub | sed 's,$,\\n,g' | tr -d '\n')" \
    '.transports.docker["ghcr.io/ii"][].rekorPublicKeyData = $REKOR_PUB | .transports.docker["ghcr.io/ii"][].fulcio.caData = $FULCIO_PUB' \
    files/usr/etc/containers/policy.json \
    )" \
    > files/usr/etc/containers/policy.json

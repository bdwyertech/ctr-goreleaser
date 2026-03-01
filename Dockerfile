ARG DOCKER_TAG="1.25"

FROM ghcr.io/sigstore/cosign/cosign:v3.0.5 AS cosign-bin
FROM  ghcr.io/anchore/syft:v1.41.2 AS syft-bin
FROM ghcr.io/goreleaser/goreleaser:v2.13.3 AS goreleaser-bin

FROM golang:$DOCKER_TAG-alpine
RUN apk add --no-cache git bash curl

COPY --from=cosign-bin /ko-app/cosign /usr/local/bin/cosign
COPY --from=syft-bin /syft /usr/local/bin/syft
COPY --from=goreleaser-bin /usr/bin/goreleaser /usr/local/bin/goreleaser


COPY scripts/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

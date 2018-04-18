FROM alpine:edge

ARG VERSION=v0.6.9

ENV RANCHER_COMPOSE_VERSION ${VERSION}
ENV RANCHER_COMPOSE_URL https://github.com/rancher/cli/releases/download/${RANCHER_COMPOSE_VERSION}/rancher-linux-amd64-${RANCHER_COMPOSE_VERSION}.tar.gz

RUN apk add --update --no-cache --virtual .build-deps ca-certificates curl tar && \
	curl -sSL "${RANCHER_COMPOSE_URL}" | tar -xzp -C /usr/local/bin/ --strip-components=2 && \
        apk del .build-deps

WORKDIR /apps

CMD ["rancher", "--help"]

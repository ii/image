ARG VERSION="${VERSION:-latest}"
FROM ghcr.io/ublue-os/silverblue-main:${VERSION}
COPY cosign.pub /usr/etc/pki/containers/ii.pub
COPY files /
RUN rm -fr /tmp/* /var/* \
    && ostree container commit

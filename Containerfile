ARG VERSION="${VERSION:-latest}"
FROM ghcr.io/ublue-os/silverblue-main:${VERSION}
COPY files /
RUN bootupctl backend generate-update-metadata
RUN flatpak remote-add --installation=image --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && \
  flatpak install --installation=image -y org.mozilla.firefox \
  flatpak install --installation=image -y com.slack.Slack \
  flatpak install --installation=image -y net.sonic_pi.SonicPi \
  flatpak install --installation=image -y edu.mit.Scratch
COPY cosign.pub /usr/etc/pki/containers/ii.pub
RUN rm -fr /tmp/* /var/* \
    && ostree container commit

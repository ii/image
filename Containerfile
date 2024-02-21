ARG VERSION="${VERSION:-latest}"
ARG FLATPAKS_INSTALL=true
FROM ghcr.io/ublue-os/silverblue-main:${VERSION}
COPY files /
COPY cosign.pub /usr/etc/pki/containers/ii.pub
RUN sed -i -e '0,/enabled=0/s//enabled=1/' /etc/yum.repos.d/fedora-updates-testing.repo && \
  rpm-ostree install \
    vim \
    gdisk \
    bootupd \
    grub2 \
    ostree-grub2 \
    grub2-efi-x64 \
    efibootmgr \
    nc \
    cloud-utils \
    strace \
    docker
RUN bootupctl backend generate-update-metadata && \
  echo -e '\n\nii ALL=(ALL) NOPASSWD:ALL\n\n' >> /etc/sudoers
COPY --from=cgr.dev/chainguard/dive:latest /usr/bin/dive /usr/bin/dive
COPY --from=cgr.dev/chainguard/flux:latest /usr/bin/flux /usr/bin/flux
COPY --from=cgr.dev/chainguard/helm:latest /usr/bin/helm /usr/bin/helm
COPY --from=cgr.dev/chainguard/ko:latest /usr/bin/ko /usr/bin/ko
COPY --from=cgr.dev/chainguard/minio-client:latest /usr/bin/mc /usr/bin/mc
COPY --from=cgr.dev/chainguard/kubectl:latest /usr/bin/kubectl /usr/bin/kubectl
RUN curl -Lo ./kind "https://github.com/kubernetes-sigs/kind/releases/latest/download/kind-$(uname)-amd64" && \
    chmod +x ./kind && \
    mv ./kind /usr/bin/kind
RUN wget https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 -O /tmp/docker-compose && \
    install -c -m 0755 /tmp/docker-compose /usr/bin
RUN systemctl enable docker.socket && \
    systemctl enable podman.socket
RUN [ "$FLATPAKS_INSTALL" = "true" ] && flatpak remote-add --installation=image --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && \
  flatpak install --installation=image -y org.mozilla.firefox net.sonic_pi.SonicPi edu.mit.Scratch
RUN rm -fr /tmp/* /var/* \
    && ostree container commit

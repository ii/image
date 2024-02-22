# image

> A Fedora Silverblue image with some development packages built in

**about**

- automatically staged updates
- updates are applied on reboot
- image is signed

## Switching to the image

reset to a clean state
```shell
rpm-ostree reset
```

rebase to the image
```shell
rpm-ostree rebase ostree-unverified-registry:ghcr.io/ii/image:latest
```
(as root)
and reboot

then rebase to the signed version
```shell
rpm-ostree rebase ostree-image-signed:docker://ghcr.io/ii/image:latest
```

## Making changes

to add new files to the file system add them hierarchically in the [./files/](./files/) directory.

new packages are added in the [./Containerfile](./Containerfile) like so:

```dockerfile
RUN rpm-ostree override remove \
  PACKAGE_TO_REMOVE_1 \
  PACKAGE_TO_REMOVE_2 \
  PACKAGE_TO_REMOVE_3 \
  --install=PACKAGE_TO_INSTALL_1 \
  --install=PACKAGE_TO_INSTALL_2 \
  --install=PACKAGE_TO_INSTALL_3
```

services are managed inline with `systemctl enable` and `systemctl disable`

## No-time iteration

given an image is built in CI and pushed

```shell
rpm-ostree upgrade
rpm-ostree apply-live
```

## Build image with bootc-image-builder

build a qcow2 image with the following

```shell
mkdir -p ./output
sudo podman run \
    --rm \
    -it \
    --privileged \
    --pull=newer \
    --security-opt label=type:unconfined_t \
    -v $(pwd)/output:/output \
    quay.io/centos-bootc/bootc-image-builder:latest \
    --type qcow2 \
    ghcr.io/ii/image:latest
```

to output to `./output/qcow2/disk.qcow2`.

## Build ISO with isogenerator

```shell
sudo podman run \
  --rm --privileged \
  -v ./output:/isogenerator/output \
  -e IMAGE_REPO="ghcr.io/ii" \
  -e IMAGE_NAME="image" \
  -e VARIANT="Silverblue" \
  -e IMAGE_TAG="latest" \
  -e VERSION="39" \
  -e ARCH=x86_64 \
  -e ACTION_REPO=ublue-os/isogenerator \
  -e ACTION_REF=a8cdedd915546b69c1e76036f85759b1f35cd029 \
  ghcr.io/ublue-os/isogenerator
```

## Verifying an image

verify an image is signed by this repo's key with the following command

```shell
cosign verify --key ./cosign.pub IMAGE
```

## Equinix Metal iPXE booting

read [this doc](./equinix-metal-ipxe-boot/README.md)

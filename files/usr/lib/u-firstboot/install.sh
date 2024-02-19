#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

# BEGIN setup ii user
useradd -g wheel -u 1000 --create-home ii
# END setup ii user

# BEGIN grow root disk partition
ROOT_PART="$(findmnt -n / | awk '{print $2}' | sed 's,/dev/\(.*\)\[.*,\1,g')"
ROOT_DISK="$(lsblk -J \
    | jq -r --arg ROOT_PART "$ROOT_PART" '.blockdevices[] | select(.children!=null) | select(.children[].name==$ROOT_PART) | .name')"
ROOT_DISK_FSTYPE="$(lsblk -fJ \
    | jq -r --arg ROOT_PART "$ROOT_PART" '.blockdevices[] | select(.children!=null) | .children[] | select(.name==$ROOT_PART) | .fstype')"
growpart /dev/"$ROOT_DISK" 4 --verbose
case "$ROOT_DISK_FSTYPE" in
    btrfs)
        btrfs filesystem resize max /
        ;;
    ext*)
        resize2fs /dev/"$ROOT_PART"
        ;;
    xfs)
        xfs_growfs /dev/"$ROOT_PART"
        ;;
    *)
        echo "notice: the filesystem type $ROOT_DISK_FSTYPE for the root fs is not plumped in for auto resize"
        ;;
esac
# END grow root disk partition

touch /var/lib/u-firstbooted

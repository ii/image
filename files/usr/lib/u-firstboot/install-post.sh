#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

# BEGIN later stage ii user password change
echo "Waiting for GDM to be live"
until pgrep gdm --exact --list-name; do
    sleep 1s
done
until chpasswd <<< 'ii:ii'; do
    sleep 5s
done
# END later stage ii user password change

touch /var/lib/u-firstbooted-post

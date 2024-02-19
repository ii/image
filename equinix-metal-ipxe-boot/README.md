# Equinix Metal iPXE boot

when creating a machine, choose OS iPXE and put in the URL

> https://raw.githubusercontent.com/ii/image/main/equinix-metal-ipxe-boot/ipxe.txt

``` shell
metal device create \
    --ipxe-script-url https://raw.githubusercontent.com/ii/image/main/equinix-metal-ipxe-boot/ipxe.txt \
    --operating-system custom_ipxe \
    --plan c2.medium.x86 \
    --metro sv \
    --hostname core \
    --output yaml \
    core
```

``` 
Booting from PXE Device 1: NIC in Slot 2 Port 1

>>Start PXE over IPv4.
  Station IP address is 147.75.71.61

  Server IP address is 145.40.83.140
  NBP filename is ipxe.efi
  NBP filesize is 1034240 Bytes
 Downloading NBP file...

  Succeed to download NBP file.
iPXE initialising devices...ok



iPXE 1.0.0+ -- Open Source Network Boot Firmware -- https://ipxe.org
Features: DNS HTTP HTTPS NFS TFTP VLAN EFI Menu
Welcome to Neverland!
Booting from net0...
net0: ec:0d:9a:bf:3d:10 using ConnectX-4Lx on 0000:01:00.0 (Ethernet) [open]
  [Link:up, TX:0 TXE:1 RX:0 RXE:0]
  [TXE: 1 x "Network unreachable (https://ipxe.org/28086090)"]
Configuring (net0 ec:0d:9a:bf:3d:10)... ok
net0: 147.75.71.61/255.255.255.254 gw 147.75.71.60
net0: fe80:81::/127 gw fe80::400:deff:fead:beef (no address)
net0: fe80::ee0d:9aff:febf:3d10/64
net1: fe80::ee0d:9aff:febf:3d11/64 (inaccessible)
Next server: 145.40.83.140
Filename: http://tinkerbell.sv15.packet.net/auto.ipxe
http://tinkerbell.sv15.packet.net/auto.ipxe... ok
auto.ipxe : 789 bytes [script]
Tinkerbell Boots iPXE
Debug Trace ID: d1534d9d26f0cc307f1ecb2f1fafd692
http://tinkerbell.sv15.packet.net/phone-home.......... ok
https://raw.githubusercontent.com/ii/image/main/equinix-metal-ipxe-boot/ipxe.txt... ok
https://builds.coreos.fedoraproject.org/prod/streams/stable/builds/39.20240112.3.0/x86_64/fedora-coreos-39.20240112.3.0-live-kernel-x86_64.... ok
https://builds.coreos.fedoraproject.org/prod/streams/stable/builds/39.20240112.3.0/x86_64/fedora-coreos-39.20240112.3.0-live-initramfs.x86_64.img... ok
EFI stub: Loaded initrd from LINUX_EFI_INITRD_MEDIA_GUID device path

```

## TODO

- [ ] automatically install the image built in this repo

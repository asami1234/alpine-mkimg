#!/bin/sh -e
set -x

HOSTNAME="$1"
if [ -z "$HOSTNAME" ]; then
echo "usage: $0 hostname"
exit 1
fi

cleanup() {
rm -rf "$tmp"
}

makefile() {
OWNER="$1"
PERMS="$2"
FILENAME="$3"
cat > "$FILENAME"
chown "$OWNER" "$FILENAME"
chmod "$PERMS" "$FILENAME"
}

rc_add() {
mkdir -p "$tmp"/etc/runlevels/"$2"
ln -sf /etc/init.d/"$1" "$tmp"/etc/runlevels/"$2"/"$1"
}

tmp="$(mktemp -d)"
trap cleanup EXIT

mkdir -p "$tmp"/etc
makefile root:root 0644 "$tmp"/etc/hostname <<EOF
$HOSTNAME
EOF

mkdir -p "$tmp"/etc/network
makefile root:root 0644 "$tmp"/etc/network/interfaces <<EOF
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.0.2.20
    netmask 255.255.255.0
EOF

mkdir -p "$tmp"/etc/apk
makefile root:root 0644 "$tmp"/etc/apk/world <<EOF
bash
vim
openssh
parted
EOF

mkdir -p "$tmp"/etc/ssh
makefile root:root 0644 "$tmp"/etc/ssh/sshd_config <<EOF
PermitRootLogin yes
EOF

mkdir -p "$tmp"/etc/local.d
cp /root/nwipe "$tmp"/etc/local.d/nwipe

# =------------------------------------------------------------=
# Hello preseed script, my new friend.
#
# Note the single quotes around the EOF, to avoid evaluation
# at the time genapkovl runs.
# =------------------------------------------------------------=
makefile root:root 0755 "$tmp"/etc/local.d/preseed.start <<'EOF'
#!/bin/sh
# Fail fast, if we make it onto a live system.
# test "$(hostname)" = "preseed" || exit 111
# Here would be the preseed script in earnest. One that sets
# the hostname to something else than `preseed`, or at least
# makes sure the /etc/local.d/preseed.start isn't carried over.
# Lest you're a glutton for punishment.
echo "preseeded at $(date)" >> /root/preseeded.txt
echo "root":"root" | chpasswd
chmod +x /etc/local.d/nwipe
cp /etc/local.d/nwipe /usr/local/bin
EOF

rc_add devfs sysinit
rc_add dmesg sysinit
rc_add mdev sysinit
rc_add hwdrivers sysinit
rc_add modloop sysinit

rc_add hwclock boot
rc_add modules boot
rc_add sysctl boot
rc_add hostname boot
rc_add bootmisc boot
rc_add syslog boot
# we want our preseed to run & have network while at it
rc_add networking boot
rc_add local boot
rc_add sshd boot

rc_add mount-ro shutdown
rc_add killprocs shutdown
rc_add savecache shutdown

tar -c -C "$tmp" etc | gzip -9n > $HOSTNAME.apkovl.tar.gz

#!/bin/sh -e

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
iface eth0 inet dhcp
EOF

# copy nwipe bin
# cp nwipe "$tmp/usr/bin"

mkdir -p "$tmp"/etc/local.d
# =------------------------------------------------------------=
# Hello preseed script, my new friend.
#
# Note the single quotes around the EOF, to avoid evaluation
# at the time genapkovl runs.
# =------------------------------------------------------------=
makefile root:root 0755 "$tmp"/etc/local.d/preseed.start <<'EOF'
#!/bin/sh
# Fail fast, if we make it onto a live system.
test "$(hostname)" = "preseed" || exit 111
# Here would be the preseed script in earnest. One that sets
# the hostname to something else than `preseed`, or at least
# makes sure the /etc/local.d/preseed.start isn't carried over.
# Lest you're a glutton for punishment.
echo "preseeded at $(date)" >> /root/preseeded.txt
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

rc_add mount-ro shutdown
rc_add killprocs shutdown
rc_add savecache shutdown

tar -c -C "$tmp" etc | gzip -9n > $HOSTNAME.apkovl.tar.gz

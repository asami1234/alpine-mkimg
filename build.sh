#!/bin/sh
chmod +x /root/aports/scripts/mkimg.preseed.sh
chmod +x /root/aports/scripts/genapkovl-preseed.sh

cd ~/aports/scripts/
sh mkimage.sh --tag edge \
 --outdir ~/iso \
 --arch x86_64 \
 --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
 --profile preseed
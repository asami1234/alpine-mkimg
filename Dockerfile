FROM alpine:edge
WORKDIR /root
USER root

RUN apk update
RUN apk add alpine-sdk build-base apk-tools alpine-conf busybox fakeroot syslinux xorriso squashfs-tools sudo
RUN apk add mtools dosfstools grub-efi

RUN git clone --depth=1 https://gitlab.alpinelinux.org/alpine/aports.git /root/aports
RUN abuild-keygen -ian

COPY mkimg.preseed.sh /root/aports/scripts/mkimg.preseed.sh
COPY genapkovl-preseed.sh /root/aports/scripts/genapkovl-preseed.sh
COPY build.sh .
COPY nwipe-alpine/nwipe .

CMD ["tail", "-f", "/dev/null"]

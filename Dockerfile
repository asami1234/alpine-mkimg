FROM alpine:edge
WORKDIR /root
USER root

RUN apk update
RUN apk add alpine-sdk build-base apk-tools alpine-conf busybox fakeroot syslinux xorriso squashfs-tools sudo
RUN apk add mtools dosfstools grub-efi

RUN git clone --depth=1 https://gitlab.alpinelinux.org/alpine/aports.git /root/aports

CMD ["tail", "-f", "/dev/null"]

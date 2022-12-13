profile_preseed() {
        profile_virt
        kernel_cmdline="unionfs_size=128M console=tty0 console=ttyS0,115200"
        syslinux_serial="0 115200"
        initfs_cmdline="modules=loop,squashfs,sd-mod quiet"        
        apks="$apks util-linux bash vim openssh parted"
        apkovl="genapkovl-preseed.sh"
}

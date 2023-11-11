{
  boot.loader.grub = {
        enable = true;
        efiSupport = true;
        gfxmodeEfi = "auto";

        # Uses OSProber to find other bootloaders
        useOSProber = true;

        # Makes GRUB use the last booted boot entry by default
        default = "saved";

        # Makes GRUB install to BOOTX64.EFI, the default bootloader
        efiInstallAsRemovable = true;

        # Defines the device where GRUB is installed
        # Has to be "nodev", otherwise nix will install GRUB in BIOS mode (???WHY???)
        device = "nodev";
    };

    # Add support for ntfs drives (for some reason has to be added separately)
    boot.supportedFilesystems = [ "ntfs" ];

    # Systemd mount unit for 2tb SSD
    systemd.mounts = [{
        mountConfig = { DirectoryMode = "0755"; };
        description = "2tbSSD mount";
        options = "nofail,atime,exec,windows_names,remove_hiberfile,big_writes,uid=1000,gid=100,dmask=022,fmask=133,";
        after = [ "multi-user.target" ];
        wantedBy = [ "multi-user.target"];
        type = "ntfs-3g";
        what = "/dev/disk/by-uuid/588A45CD8A45A878";
        where = "/media/2tbSSD";
    }];
}
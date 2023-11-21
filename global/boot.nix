{
     # TODO: Configure this to use only the needed kernel modules
    # Start the rest with a systemd unit after boot

    # Generic boot process config
    boot = {
        # Bootloader config
        loader = {
            # Where the EFI system partition is mounted
            efi.efiSysMountPoint = "/boot";

            # Boot menu time
            timeout = 2;

            # Systemd-boot config
            systemd-boot = {
                enable = true;
                editor = false;
                extraInstallCommands = ''
echo "default @saved
timeout 2
console-mode max" > /boot/loader/loader.conf'';
            };
        };

        # Enables NTFS support for mounting
        supportedFilesystems = [ "ntfs-3g" ];

        # Sets up a kernel that boots on crash to save crash logs etc
        crashDump.enable = true;

        # Sets the console log level to 0 for a silent boot
        consoleLogLevel = 0;

        # Removes mandatory messages generated by nixOS scripts
        initrd.verbose = false;
    };

    # Systemd mount unit for 2tb SSD
    # TODO: Move out of here, start only after login, this is slow
    systemd.mounts = [{
        mountConfig = { DirectoryMode = "0755"; };
        description = "2tbSSD mount";
        options = "nofail,atime,exec,windows_names,remove_hiberfile,big_writes,uid=1000,gid=100,umask=0022,fmask=0022,gmask=0022";
        after = [ "multi-user.target" ];
        wantedBy = [ "multi-user.target"];
        type = "ntfs-3g";
        what = "/dev/disk/by-uuid/588A45CD8A45A878";
        where = "/media/2tbSSD";
    }];
}
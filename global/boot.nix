{
    # Generic boot process config
    boot = {
        # Bootloader config
        loader = {
            # Where the EFI system partition is mounted
            efi.efiSysMountPoint = "/boot";

            # Allows the bootloader to touch efi variables
            efi.canTouchEfiVariables = true;

            # Systemd-boot config
            systemd-boot = {
                enable = true;
                editor = false;
                extraInstallCommands = ''
echo "default @saved
timeout 3
console-mode keep" > /boot/loader/loader.conf'';
            };

            # Sets the loader timeout to 3 sec, just in case it does something lol
            timeout = 3;
        };

        # Kernel modules loaded in second stage of boot process
        kernelModules = [ "kvm-amd" ];

        # Enables NTFS support for mounting
        supportedFilesystems = [ "ntfs-3g" ];

        # Boot initial ramdisk config
        initrd = {
            # Kernel modules that are loaded on-demonad in initrd
            availableKernelModules = [ 
                "nvme" 
                "xhci_pci" 
                "ahci" 
                "usbhid" 
                "usb_storage" 
                "sd_mod" 
            ];
        };
    };
}
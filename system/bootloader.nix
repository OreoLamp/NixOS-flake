# Configures the bootloader of the system

{
    # General bootloader settings
    boot.loader.efi.canTouchEfiVariables = true;

    boot.loader.grub = {
        # Enables GRUB
        enable = true;

	# Make GRUB install itself to BOOTX64.EFI
	efiInstallAsRemovable = true;

	# Defaults to the last boot option
	default = "saved";

	# Defines the device where GRUB is installed
	# Has to be "nodev"
	# Otherwise nix will in its infinite wisdom install GRUB in BIOS mode
        device = "nodev";

	# Enables EFI mode
	efiSupport = true;

	# Graphics mode to pass to GRUB when booting in EFI mode
	gfxmodeEfi = "auto";

        # Uses OSProber to find other OS's (windows)
	useOSProber = true;
    };
}

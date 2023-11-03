# Configuration for desktop environment, sound system, any services that should always be enabled, etc
{ config, pkgs, lib, inputs, outputs, ...}:
{
    services = {
        # Enables the X11 server
	# Needed for GNOME even on wayland (bruh)
        xserver.enable = true;

        # Yeets xterm
	xserver.excludePackages = [ pkgs.xterm ];

	# Enables GNOME
	xserver.displayManager.gdm.enable = true;
	xserver.desktopManager.gnome.enable = true;

	# Removes gnome core utils, the only one of them that I want is nautilus
	gnome.core-utilities.enable = false;
    };

    # Yeets gnome-tour
    environment.gnome.excludePackages = with pkgs; [ 
      gnome-tour
      evolutionWithPlugins
      gnome.gnome-user-share
    ];

    # Sound config
    sound.enable = true;
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;

    # Pipewire config
    services.pipewire = {
        enable = true;
	alsa.enable = true;
	# alsa.support32bit = true;
	pulse.enable = true;
	jack.enable = true;
    };

    # Enables gnome-keyring for keyring management
    services.gnome.gnome-keyring.enable = true;

    # Enables flatpaks (TODO: Move from here)
    services.flatpak.enable = true;

    # Enables CUPS for printing
    services.printing.enable = true;
}

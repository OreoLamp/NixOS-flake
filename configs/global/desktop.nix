{ pkgs, ...}:
{
    # Enables xdg portals, even for flatpaks (hopefully)
    xdg.menus.enable = true;
    xdg.portal = {
        enable = true;
        wlr.enable = true;
        extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    };

    # TODO: xdg mime apps
    xdg.mime.enable = true;

    # Enables icon cache for gtk
    gtk.iconCache.enable = true;

    # Enables flatpaks
    services.flatpak.enable = true;

    # Enables openGL
    hardware.opengl.enable = true;

    # Enables xwayland
    programs.xwayland.enable = true;

    # Sound stuff
    hardware.pulseaudio.enable = false;
    
    # Pipewire settings
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        pulse.enable = true;
        jack.enable = true;
    };

    # Enables printing via CUPS
    services.printing.enable = true;

    # Enables locate services, and uses plocate for them
    services.locate = {
        enable = true;
        package = pkgs.plocate;
        # TODO: Figure out a way to auto-update the database in a sane way
        interval = "never";
        # set to null because otherwise plocate complains lol
        localuser = null;
    };
}

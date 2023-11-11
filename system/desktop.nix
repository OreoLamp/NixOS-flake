{ pkgs, ...}:
{
    users.users.eero.packages = with pkgs; [
        glib
    ];

    # Enables xdg portals, even for flatpaks (hopefully)!
    xdg.menus.enable = true;
    xdg.portal = {
        enable = true;
        wlr.enable = true;
        extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    };

    # TODO: xdg mime apps
    xdg.mime.enable = true;
    
    # Config for gtk and qt
    gtk.iconCache.enable = true;
    qt = {
        enable = true;
        platformTheme = "gnome";
        style = "adwaita-dark";
    };

    # Enables flatpaks
    services.flatpak.enable = true;

    # Makes electron stuff work better???
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    # Enables openGL
    hardware.opengl.enable = true;
    
    # Enables xwayland
    programs.xwayland.enable = true;

    # Sound stuff
    sound.enable = true;
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
}
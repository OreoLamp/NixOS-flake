{ pkgs, config, ... }:
{
    # Theme packages
    users.users.eero.packages = with pkgs; [
        quintom-cursor-theme
        tokyo-night-gtk
        gnome.adwaita-icon-theme
    ];

    # Cursor theme
    hm.home.pointerCursor = {
            package = pkgs.quintom-cursor-theme;
            name = "Quintom_Ink";
    };

    # Qt config
    qt = {
        enable = true;
        platformTheme = "gnome";
        style = "adwaita-dark";
    };

    # GTK config
    hm.gtk = {
        enable = true;

        # Moves the gtk2 config folder to a sane location
        gtk2.configLocation = "${config.environment.sessionVariables.XDG_CONFIG_HOME}/gtk-2.0/gtkrc";

        # General gtk theme
        theme = {
            package = pkgs.tokyo-night-gtk;
            name = "Tokyonight-Dark-B";
        };

        # Icon theme
        iconTheme = {
          package = pkgs.gnome.adwaita-icon-theme;
          name = "Adwaita";
        };
    };
}
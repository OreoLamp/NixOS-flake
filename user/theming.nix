{ pkgs, config, ... }:
{
    # Theme packages
    users.users.eero.packages = with pkgs; [
        quintom-cursor-theme
        tokyo-night-gtk
    ];

    # Cursor theme
    home.pointerCursor = {
            package = pkgs.quintom-cursor-theme;
            name = "Quintom_Ink";
    };
    
    # qt config
    qt = {
        enable = true;
        platformTheme = "gnome";
    };

    # GTK config
    hm.gtk = {
        enable = true;

        # Moves the gtk2 config folder to a sane location
        gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

        # General gtk theme
        theme = {
            package = pkgs.tokyo-night-gtk;
            name = "Tokyo-Night-B";
        };
    };
}
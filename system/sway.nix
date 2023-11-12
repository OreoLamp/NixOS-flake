{ lib, config, pkgs, ... }:
{
    users.users.eero.packages = with pkgs; [
        waybar
    ];

    # Enables sway to begin with
    programs.sway = {
        enable = true;
        wrapperFeatures.gtk = true;
    };

    # Home-manager sway config
    hm.wayland.windowManager.sway = {
        enable = true;
        config = {

            # Monitor config
            output = {
                HDMI-A-1 = {
                    mode = "1920x1080@60Hz";
                    position = "0,360";
                };
                DP-1 = {
                    mode = "2560x1440@143.912Hz";
                    position = "1920,0";
                };
            };

            # Keyboard layout
            input = {
                "type:keyboard" = {
                    xkb_layout = "fi";
                    xkb_model = "pc105";
                };
            };

            # Keybindings
            modifier = "Mod4";
            keybindings = 
                let mod = config.hm.wayland.windowManager.sway.config.modifier;
                in lib.mkOptionDefault {
                    "${mod}+Shift+s" = 
                    ''exec wayshot -s "$(slurp)" -e png --stdout \| wl-copy; \
                    tee $XDG_PICTURES_DIR/screenshots/(date "+%Y-%m-%d %H-%M-%S").png'';
                };

            # Font settings
            fonts = {
                names = [ "Blinker" "Noto Sans" "Font Awesome 6 Free" "Font Awesome 6 Brands" ];
                style = "Regular";
                size = 12.0;
            };

            # Default applications
            terminal = "kitty";
            menu = "tofi-run | xargs swaymsg exec --";

            # Set background color to black so my eyes don't get blasted out
            # Should only be used if an app doesn't fill the entire window
            colors.background = "#000000";

            # Remove titlebars
            window.titlebar = false;
            floating.titlebar = false;
        };
    };
}
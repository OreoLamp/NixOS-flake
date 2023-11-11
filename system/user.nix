{ pkgs, inputs, outputs, ... }:
{
    imports = [
        # Shell config
        ./shell.nix

        # Git config
        ./git.nix

        # Sway config
        ./sway.nix

        # VSCode config
        ./vscode.nix

        # Security stuff
        ./security.nix
    ];

    # Makes zsh the default user shell
    users.defaultUserShell = pkgs.zsh;

    users.users.eero = {
        isNormalUser = true;
        description = "Eero Lampela";
        extraGroups = [ "networkmanager" "wheel" ];

        # User packages
        packages = with pkgs; [
            neofetch # System state thing?
            piper # Logitech mouse config
            mpv # Video player
            nomacs # Image viewer with a GUI
            peazip # Archive extractor with a GUI
            firefox # Web browser
            libsForQt5.okular # PDF / other document viewer
            inkscape # Vector graphics editor
            gimp # Image editor
            audacity # Audio / waveform toolbox
            obs-studio # Screen recording
            qbittorrent # Torrents
            jetbrains-toolbox # More code editors
            gradience # Adwaita theme generator
            mullvad-vpn # VPN
            calibre # e-book library
            baobab # Disk space utility
            font-manager # Exactly what the name suggests
            signal-desktop # End to end encrypted messaging platform
            telegram-desktop # Another messaging platform, used for student stuff
            spotify # Music player of choice
            spotifywm # Set spotify window name properly
            spotifyd # Spotify daemon
            glib # I think this fixes flatpak mime issues
            tofi # Launcher / app menu
            eww-wayland # Widgets
            swaylock # Lock screen
            wl-clipboard # Clipboard (duh)
            wayshot # Screenshot tool, faster than grim
            slurp # Select area from screen for wayshot
            cliphist # Clipboard history
            imv # Super light image viewer
            wev # Wayland event viewer, for debugging hyprland mostly
            wlr-randr # Check monitor shit on wayland
            vscode # vscode lol
            nil # nix language server
        ];
    };

    # Makes home-manager load stuff
    home-manager = {
        extraSpecialArgs = { inherit inputs outputs; };
        users.eero = {
            programs.home-manager.enable = true;
            home.stateVersion = "23.05";
            xdg.enable = true;
            home = {
                username = "eero";
                homeDirectory = "/home/eero";
            };
            systemd.user.startServices = "sd-switch";
        };
    };
}
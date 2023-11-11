{ pkgs, inputs, outputs, ... }:
{
    imports = [
        # Shell
        ./shell.nix

        # Sway
        ./sway.nix

        # VSCode
        ./vscode.nix

        # Security stuff
        ./security.nix

        # Random tools and programs
        ./misc-programs.nix
    ];

    # Makes zsh the default user shell
    users.defaultUserShell = pkgs.zsh;

    users.users.eero = {
        isNormalUser = true;
        description = "Eero Lampela";
        extraGroups = [ "networkmanager" "wheel" ];

        # User packages
        packages = with pkgs; [
            jetbrains-toolbox # More code editors
            gradience # Adwaita theme generator
            baobab # Disk space utility
            font-manager # Exactly what the name suggests
            wev # Wayland event viewer, for debugging hyprland mostly
            wlr-randr # Check monitor shit on wayland
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
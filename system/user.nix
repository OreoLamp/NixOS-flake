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

        # Enables lingering. Means systemd user units will start at boot, instead of
        # starting at login and stopping at logout. Should make logging in a lot faster.
        linger = true;

        # User packages
        packages = with pkgs; [
            gradience # Adwaita theme generator
            font-manager # Exactly what the name suggests
        ];
    };

    # Makes home-manager load stuff
    # TODO: Get rid of the shitshow that is home-manager
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

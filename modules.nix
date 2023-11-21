{ lib, inputs, ... }:
{
    imports = [
        # Hardware config
        ./global/hardware-configuration.nix

        # Boot config and such
        ./global/boot.nix

        # System-wide graphics, sound, xdg, printing, flatpaks etc
        ./global/desktop.nix

        # Basic setup for locale, keyboard layout, etc
        ./global/setup.nix

        # Systemd units, services, and config
        ./global/systemd.nix

        # Add an alias "hm" for "home-manager.users.eero"
        ( lib.mkAliasOptionModule [ "hm" ] [ "home-manager" "users" "eero" ] )

        # User profile
        inputs.home-manager.nixosModules.home-manager

        # Shell
        ./user/shell.nix

        # Sway
        ./user/sway.nix

        # Security stuff
        ./user/security.nix

        # Random tools and programs
        ./user/misc-programs.nix

        # Font config
        ./user/fonts.nix
    ];
}
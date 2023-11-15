{ pkgs, config, ... }:
{
    # Packages that need to be explicitly installed for the user
    users.users.eero.packages = with pkgs; [
            gnupg # For some reason have to manually specify this to be installed???
            libsecret # Required for vscode gpg integration
    ];

    # Enables gnome-keyring and seahorse
    security.pam.services.eero.enableGnomeKeyring = true;
    services.gnome.gnome-keyring.enable = true;
    programs.seahorse.enable = true;

    # gpg setup
    hm.programs.gpg.enable = true;
    hm.programs.gpg.homedir = "${config.hm.xdg.dataHome}/gnupg";
    hm.services.gpg-agent.enable = true;
    hm.services.gpg-agent.pinentryFlavor = "gnome3";

    # Enables polkit
    security.polkit.enable = true;

    # Enables rtkit
    security.rtkit.enable = true;
}
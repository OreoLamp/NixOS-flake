{ pkgs, config, ... }:
{
    # Packages that need to be explicitly installed for the user
    users.users.eero.packages = with pkgs; [
        gnupg # For some reason have to manually specify this to be installed???
        libsecret # Required for vscode gpg integration
        gcr # Gnome crypto services (Their impl has the best ui lol)
    ];

    # Enables gnome-keyring and seahorse
    security.pam.services.eero.enableGnomeKeyring = true;
    services.gnome.gnome-keyring.enable = true;
    programs.seahorse.enable = true;

    # gpg setup
    hm.programs.gpg.enable = true;
    # TODO: Fix this, this apparently does not work???
    hm.programs.gpg.homedir = "${config.hm.xdg.dataHome}/gnupg";
    hm.services.gpg-agent.enable = true;
    hm.services.gpg-agent.pinentryFlavor = "gnome3";

    # Enables polkit
    security.polkit.enable = true;

    # Enables rtkit
    security.rtkit.enable = true;

    # SSH config
    # TODO: Set up an SSH server
    programs.ssh = {
        startAgent = true;
    };

    # Adds a systemd service for starting the gnome polkit authentication agent on login
    # This is cursed as fuck but nixos has apparently no sane way of doing this
    systemd = {
        user.services.polkit-gnome-authentication-agent-1 = {
            description = "polkit-gnome-authentication-agent-1";
            wantedBy = [ "graphical-session.target" ];
            wants = [ "graphical-session.target" ];
            after = [ "graphical-session.target" ];
            serviceConfig = {
                Type = "simple";
                ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
                Restart = "on-failure";
                RestartSec = 1;
                TimeoutStopSec = 10;
            };
        };
    };
}
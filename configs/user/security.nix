{ pkgs, config, ... }:
{
    # Packages that need to be explicitly installed for the user
    users.users.eero.packages = with pkgs; [
        gnupg # For some reason have to manually specify this to be installed???
        libsecret # Required for vscode gpg integration
    ];

    # Enables gnome-keyring and seahorse
    # security.pam.services.eero.enableGnomeKeyring = true;
    services.gnome.gnome-keyring.enable = true;
    programs.seahorse.enable = true;

    # GPG agent config
    programs.gnupg.agent = {
        enable = true;

        # Makes gpg use the gnome3 variant of the password prompt program
        pinentryFlavor = "gnome3";

        settings = {
            # Yeets $HOME/.gnupg to a more sane location
            homedir = "${config.users.users.eero.home}/.local/share/gnupg";

            # Logfile path
            log-file = "${config.users.users.eero.home}/.local/share/gnupg/log";
        };
    };

    # General security system config
    security = {
        
        # sudo config
        sudo = {
            # Technically unnecessary but i'd rather be explicit about this
            enable = true;

            # Disables password prompt timeout, enables insults lol
            extraConfig = ''
Defaults passwd_timeout=0
Defaults insults
'';
        };

        # Enables polkit
        polkit.enable = true;

        # Enables rtkit
        rtkit.enable = true;

        # Enables TPM2
        tpm2.enable = true;
    };
}
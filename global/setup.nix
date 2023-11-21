{ pkgs, ... }:
{
    # System-wide packages that I want always available
    environment.systemPackages = with pkgs; [
        # Basic utility packages
        file lshw pciutils psmisc curl strace lsof
        # Conveniences
        du-dust unar btop tmux nnn nvimpager nix-tree
    ];

    # Networking config
    networking.hostName = "desktop-nix";
    networking.networkmanager.enable = true;

    # Keyboard layout stuff
    services.xserver = {
        layout = "fi";
        xkbModel = "pc105";
    };

    # Makes console settings follow xkb settings
    console.useXkbConfig = true;

    # Locale and timezone stuff
    time.timeZone = "Europe/Helsinki";
    i18n = {
        supportedLocales = [ "all" ];
        defaultLocale = "en_US.UTF-8";
        extraLocaleSettings = {
            LANG = "en_US.UTF-8";
            LANGUAGE = "en_US.UTF-8";
            LC_ADDRESS = "fi_FI.UTF-8";
            LC_IDENTIFICATION = "en_US.UTF-8";
            LC_MEASUREMENT = "fi_FI.UTF-8";
            LC_MONETARY = "fi_FI.UTF-8";
            LC_NAME = "fi_FI.UTF-8";
            LC_NUMERIC = "fi_FI.UTF-8";
            LC_PAPER = "fi_FI.UTF-8";
            LC_TIME = "en_DK.UTF-8";
        };
    };

    # Enables locate services, and uses plocate for them
    services.locate = {
        enable = true;
        package = pkgs.plocate;
        # TODO: Figure out a way to auto-update the database in a sane way
        interval = "never";
        # set to null because otherwise plocate complains lol
        localuser = null;
    };
}
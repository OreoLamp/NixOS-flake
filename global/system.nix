{ pkgs, ... }:
{
    imports = [ 
        # Config for nix itself
        ./nix.nix

        # Hardware config
        ./hardware-configuration.nix

        # Boot config and such
        ./boot.nix

        # Font config
        ./fonts.nix

        # Basic system config
        ./system.nix

        # Generic desktop config stuff
        ./desktop.nix

        # User config (testing whether loading it from here works?)
        ./user/user.nix
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
        interval = "never";
        localuser = null;
    };

    # System-wide packages that I want always available
    environment.systemPackages = with pkgs; [
        # Basic utility packages
        file lshw pciutils psmisc curl strace
        # Conveniences
        du-dust unar btop tmux nnn nvimpager nix-tree
    ];

    # Eneables nix-index, a file database for nixpkgs
    programs.nix-index.enable = true; 

    # Disables command-not-found, since it conflicts with nix-index
    programs.command-not-found.enable = false;

    # Enables polkit
    security.polkit.enable = true;

    # Enables rtkit
    security.rtkit.enable = true;

    # System-wide neovim config
    programs.neovim = {
        enable = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;
    };
}
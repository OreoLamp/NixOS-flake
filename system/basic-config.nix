{
    # Hostname
    networking.hostName = "desktop-nix";

    # Enable networking
    networking.networkmanager.enable = true;

    # Define what locales are supported to begin with
    i18n.supportedLocales = [ "all" ];

    # Timezone
    time.timeZone = "Europe/Helsinki";

    # Localization
    i18n.defaultLocale = "en_US.UTF-8";

    # Extra locale settings
    i18n.extraLocaleSettings = {
        LANG = "en_US.UTF-8";
	LANGUAGE = "en_US.UTF-8";
        LC_ADDRESS = "fi_FI.UTF-8";
	LC_IDENTIFICATION = "fi_FI.UTF-8";
	LC_MEASUREMENT = "fi_FI.UTF-8";
	LC_MONETARY = "fi_FI.UTF-8";
	LC_NAME = "fi_FI.UTF-8";
	LC_NUMERIC = "fi_FI.UTF-8";
	LC_PAPER = "fi_FI.UTF-8";
	LC_TIME = "en_DK.UTF-8";
    };

    # xkbcomp keyboard stuff, set in xserver (for some reason)
    services.xserver = {
        layout = "fi";
	xkbModel = "pc105";
    };

    # Make virtual console use xkb settings
    console.useXkbConfig = true;
}

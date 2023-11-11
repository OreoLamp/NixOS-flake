{
    lib,
    inputs,
    ... 
}: 
{
    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It's perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "23.05"; # Did you read the comment?

    # Allow non-FOSS packages
    nixpkgs.config.allowUnfree = true;

    # Enable nix-command and flakes
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    imports = [ 
        # Add an alias "hm" for "home-manager.users.eero"
        ( lib.mkAliasOptionModule [ "hm" ] [ "home-manager" "users" "eero" ] )

        # User profile
        inputs.home-manager.nixosModules.home-manager

        # Hardware config
        ./hardware-configuration.nix

        # Boot config and such
        ./boot.nix

        # Font config
        ./fonts.nix

        # Basic system config
        ./system.nix

        # User config
        ./user.nix

        # Generic desktop config stuff
        ./desktop.nix
    ];

    # Firefox enablement
    # Login screen (AKA display manager, for some reason)
    # programs.regreet.enable = true;
    # services.greetd = {
    #     enable = true;
    # };
}
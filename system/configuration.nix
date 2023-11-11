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

    # Enables cliphist for clipboard "management"
    hm.services.cliphist.enable = true;

    # Btop user config
    hm.programs.btop = {
        enable = true;
        settings = {
            color_theme = "tokyo-night";
            update_ms = 1000;
            proc_sorting = "memory";
            proc_cpu_graphs = false;
            proc_filter_kernel = true;
            cpu_graph_lower = "idle";
            swap_disk = false;
            disk_free_priv = true;
            show_io_stat = true;
            io_mode = true;
        };
    };

    # Kitty config
    hm.programs.kitty = {
        enable = true;
        shellIntegration.enableZshIntegration = true;
        theme = "Tokyo Night";
    };

    # Firefox enablement
    # Login screen (AKA display manager, for some reason)
    # programs.regreet.enable = true;
    # services.greetd = {
    #     enable = true;
    # };
}
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

    # Nix configuration, as in for the nix system itself
    nix.settings = {
    	# Accepts a flake config without prompting
	accept-flake-config = true;

	# Disallow dirty git/mercurial trees
	allow-dirty = false;

	# Disallow importing within a derivation. 
	# Makes sure no builds are done at evaluation time.
	allow-import-from-derivation = false;

	# Makes nix optimize the store after every rebuild
	auto-optimise-store = true;

	# Makes nix fall back on building from source if a binary substitute fails
	fallback = true;

	# Disables synchronous flushing of metadata to disk
	# fsync causes unnecessary disk degradation
	fsync-metadata = false;

	# Disables the limit on the amount of allowed http connections
	http-connections = 0;

	# Add more log lines lol
	log-lines = 20;

	# Print a stack trace in case of expression evaluation errors
	show-trace = true;

	# Makes nix comply with XDG base directories for files in $HOME
	use-xdg-base-directories = true;

	# Enable some experimental features
	exprimental-features = [
	    
	    # Enables flakes
	    "flakes"
		
	    # nix-command, enables a ton of useful commands
	    "nix-command"
	];
    };

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
}

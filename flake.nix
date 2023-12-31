{
    description = "NixOS config initialization";

    inputs = {

        # Nixpkgs
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

        # Nixpkgs master branch (just in case lol)
        nixpkgs-master.url = "github:nixos/nixpkgs/master";

        # Home manager
        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";

        # vscode extensions url
        nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    };

    outputs = {
        self,
        nixpkgs,
        nixpkgs-master,
        home-manager,
        ...
    } @ inputs: {

        # NixOS configuration entrypoint
        # Available through 'nixos-rebuild --flake .#your-hostname'
        nixosConfigurations = {

            # Hostname
            desktop-nix = nixpkgs.lib.nixosSystem {
                specialArgs = {inherit inputs self;};
                modules = [
                    # Config for nix itself
                    ./nix.nix

                    # System-wide configs
                    ./configs/files.nix
                ];
            };
        };
    };
}
# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  hm.nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
  };

  # Sets username
  hm.home = {
    username = "eero";
    homeDirectory = "/home/eero";
  };
  
  # Enable home-manager and git
  hm.programs.home-manager.enable = true;
  hm.programs.git.enable = true;

  # Nicely reload system units when changing configs
  hm.systemd.user.startServices = "sd-switch";

  # For some reason this still requires this
  hm.home.stateVersion = "23.05";
}

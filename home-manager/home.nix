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
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # GNOME config
    ./gnome.nix

    # Qt and Gtk config
    ./gtk-and-qt.nix

    # Zsh config
    ./zsh.nix

    # Neovim config
    ./nvim.nix

    # Firefox config
    ./firefox.nix
  ];

  nixpkgs = {
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
  home = {
    username = "eero";
    homeDirectory = "/home/eero";
  };
  
  users.users.eero = {
    isNormalUser = true;
    description = "Eero Lampela";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      nvimpager
      kitty
      gimp
      libsForQt5.okular
    ];
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}

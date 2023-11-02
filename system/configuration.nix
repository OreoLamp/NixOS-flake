# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
    config, 
    pkgs,
    lib,
    inputs,
    outputs,
    hyprland,
    ... 
}:

{
  # Allow non-FOSS packages
  nixpkgs.config.allowUnfree = true;

  imports =
    [ 
      # Add an alias "hm" for "home-manager.users.eero"
      ( lib.mkAliasOptionModule [ "hm" ] [ "home-manager" "users" "eero" ] )

      # Hardware config (autoconfigured by the hardware scan)
      ./hardware-configuration.nix

      # Bootloader config
      ./bootloader.nix

      # Configs for locale, networking, console keymap, etc
      ./basic-config.nix

      # Some packages and configs that really should be installed by default, but aren't
      ./basic-packages.nix

      # Desktop environment, sound system, etc
      ./desktop-environment.nix

      # User profile
      inputs.home-manager.nixosModules.home-manager

      # GNOME config
      ../home-manager/gnome.nix

      # gtk and qt config
      ../home-manager/gtk-and-qt.nix

      # zsh config
      ../home-manager/zsh.nix

      # Neovim config
      ../home-manager/nvim.nix
      
      # Firefox config
      ../home-manager/firefox.nix

      # Git config
      ../home-manager/git.nix
    ];

  users.users.eero = {
    isNormalUser = true;
    description = "Eero Lampela";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      nvimpager
      kitty
      gimp
      libsForQt5.okular
      spotify
      spotifywm
      spotifyd
      vscode.fhs
      jetbrains.pycharm-professional
      jetbrains.clion
      jetbrains.idea-ultimate
      jetbrains-toolbox
    ];
  };

  # Home-manager config to make it load stuff
  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    users = {
      eero = import ../home-manager/home.nix;
    };
  };

  # Make nix automatically optimise the store
  nix.optimise.automatic = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
